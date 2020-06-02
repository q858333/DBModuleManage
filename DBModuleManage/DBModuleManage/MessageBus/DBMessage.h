//
//  DBMessage.h
//  CustomNotification
//
//  Created by dengbinOld on 2020/4/8.
//  Copyright © 2020 DengBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBMessage : NSObject
@property (nonatomic, strong)id data;
@property (nonatomic, copy)NSString  *messageName;

@end

NS_ASSUME_NONNULL_END
