//
//  BOSetting.m
//  BOSettings
//
//  Created by David Román Aguirre on 31/5/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import "BOSetting+Private.h"

@interface BOSetting()
@property (nonatomic) NSUserDefaults *userDefaults;
@end

@implementation BOSetting

- (instancetype)initWithKey:(NSString *)key userDefaults:(NSUserDefaults *)userDefaults {
    if (key) {
        if (self = [super init]) {
            _key = key;
            
            if (userDefaults) {
                self.userDefaults = userDefaults;
            }
            else {
                self.userDefaults = [NSUserDefaults standardUserDefaults];
            }
            [self.userDefaults addObserver:self forKeyPath:self.key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return self;
}

+ (instancetype)settingWithKey:(NSString *)key {
	return [[self alloc] initWithKey:key userDefaults:nil];
}

+ (instancetype)settingWithKey:(NSString *)key userDefaults:(NSUserDefaults *)userDefaults {
    return [[self alloc] initWithKey:key userDefaults:userDefaults];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	self.value = change[@"new"];
	if (self.valueDidChangeBlock) self.valueDidChangeBlock();
}

- (id)value {
	return [self.userDefaults objectForKey:self.key];
}

- (void)setValue:(id)value {
	if (self.value != value) {
		[self.userDefaults setObject:value forKey:self.key];
	}
}

- (void)setValueDidChangeBlock:(void (^)(void))valueDidChangeBlock {
	_valueDidChangeBlock = valueDidChangeBlock;
	if (valueDidChangeBlock) valueDidChangeBlock();
}

- (void)dealloc {
	if (self.key) [self.userDefaults removeObserver:self forKeyPath:self.key];
}

@end
