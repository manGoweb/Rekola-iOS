/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "TabBarController.h"
#import "BaseNavigationController.h"

@implementation TabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor RKPinkColor];
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)reloadData {
    NSMutableArray *controllers = self.viewControllers.mutableCopy;
    BaseNavigationController *nav = nil;
    
    if ([ContentManager manager].usingBike) {
        nav = [[BaseNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReturnBikeViewController"]];
    } else {
        nav = [[BaseNavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BikeViewController"]];
    }
    
    [controllers replaceObjectAtIndex:0 withObject:nav];
    [self setViewControllers:controllers animated:YES];
}

#pragma mark - Public methods

- (void)switchToController:(ControllerType)type withObject:(id)object {
    
    self.selectedIndex = type;
    
    if (type == ControllerTypeBike) {
        
    } else if (type == ControllerTypeMap) {
        
    } else if (type == ControllerTypeProfile) {
        
    }
}


@end
