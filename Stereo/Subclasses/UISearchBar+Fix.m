//
//  NIFMinimalColourisedSearchBar.m
//  Stereo
//
//  Created by Terry Lewis on 8/11/2015.
//  Copyright © 2015 Terry Lewis. All rights reserved.
//

#import "UISearchBar+Fix.h"
#import <objc/runtime.h>

@implementation UISearchBar (Fix)

static NSMutableArray *liveInstances;
Class backgroundClass;

- (UIView *)_fixBackgroundView{
    return objc_getAssociatedObject(self, @selector(_fixBackgroundView));
}

- (void)set_fixBackgroundView:(UIView *)_fixBackgroundView{
    objc_setAssociatedObject(self, @selector(_fixBackgroundView), _fixBackgroundView, OBJC_ASSOCIATION_ASSIGN);
}

Method instanceMethodFromClass(Class cls, SEL slc){
    return class_getInstanceMethod(cls, slc);
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        liveInstances = [NSMutableArray array];
        backgroundClass = NSClassFromString(@"UISearchBarBackground");
        SEL originalSelector = @selector(setBackgroundColor:);
        SEL swizzledSelector = @selector(_fixSetBackgroundColor:);
        
        Method originalMethod = class_getInstanceMethod(backgroundClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(backgroundClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(backgroundClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        Method deallocMethod = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
        method_exchangeImplementations(deallocMethod, class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
    });
}

- (void)swizzledDealloc{
    [self _endOverridingColourSetter];
    [self swizzledDealloc];
}

- (void)_fixLocateBackgroundView{
    if (![self _fixBackgroundView]) {
        UIView *fixView = nil;
        for (UIView *baseView in self.subviews) {
            for (UIView *view in baseView.subviews) {
                if ([view isKindOfClass:backgroundClass]) {
                    fixView = view;
                    break;
                }
            }
            if (fixView) {
                break;
            }
        }
        [self set_fixBackgroundView:fixView];
    }
}

- (void)_beginOverridingColourSetter{
    [self _endOverridingColourSetter];
    [liveInstances addObject:self];
    [self _fixLocateBackgroundView];
}

- (void)_endOverridingColourSetter{
    [liveInstances removeObject:self];
}

- (void)performMethodsWithOverride:(void(^)(UIView *fixBackgroundView))methods{
    [self _beginOverridingColourSetter];
    methods([self _fixBackgroundView]);
    [self _endOverridingColourSetter];
}

- (BOOL)shouldOverrideBackgroundSetter{
    return [liveInstances containsObject:self];
}

- (void)_fixSetBackgroundColor:(UIColor *)backgroundColor{
    UISearchBar *parentView = (UISearchBar *)self.superview;
    while (parentView && ![parentView isKindOfClass:[UISearchBar class]]) {
        parentView = (UISearchBar *)parentView.superview;
    }
    
    if ([parentView shouldOverrideBackgroundSetter] == YES) {
        [self _fixSetBackgroundColor:backgroundColor];
    }
}

@end
