//
//  LabColor.h
//  ProjectUtada
//
//  Created by Chazo on 15/8/25.
//
//

@interface LabColor : NSObject

@property (nonatomic) double lComponent;
@property (nonatomic) double aComponent;
@property (nonatomic) double bComponent;

@property (nonatomic, readonly) double redComponent;
@property (nonatomic, readonly) double greenComponent;
@property (nonatomic, readonly) double blueComponent;

@property (nonatomic, strong, readonly) UIColor *color;

@end
