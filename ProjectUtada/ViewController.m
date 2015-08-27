//
//  ViewController.m
//  ProjectUtada
//
//  Created by Chazo on 15/5/13.
//
//

#import "ViewController.h"
#import "ASHSpringyCollectionViewFlowLayout.h"

#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) double aValue;
@property (nonatomic) double bValue;
@property (nonatomic) double cValue;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ASHSpringyCollectionViewFlowLayout *collectionViewLayout;

@end

@implementation ViewController

static NSString * CellIdentifier = @"CellIdentifier";

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:CellIdentifier];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionViewLayout invalidateLayout];
    
    self.collectionView.frame = CGRectMake(0, 20, ScreenWidth, self.view.frame.size.height-20);
}

#pragma mark - UICollectionView Methods
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return 120;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                  forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - LifeCycle

#pragma mark - Delegate

#pragma mark - Event Response

#pragma mark - Private Methods

#pragma mark - Getters and Setters
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (ASHSpringyCollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        _collectionViewLayout = [[ASHSpringyCollectionViewFlowLayout alloc] init];
    }
    return _collectionViewLayout;
}

@end
