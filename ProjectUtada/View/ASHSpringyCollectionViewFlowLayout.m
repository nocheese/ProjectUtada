//
//  ASHSpringyCollectionViewFlowLayout.m
//  ProjectUtada
//
//  Created by Chazo on 15/8/25.
//
//

#import "ASHSpringyCollectionViewFlowLayout.h"

@interface ASHSpringyCollectionViewFlowLayout()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;

@property (nonatomic, assign) CGFloat latestDelta;

@end

@implementation ASHSpringyCollectionViewFlowLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.itemSize = CGSizeMake(44, 44);
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    CGRect originalRect = (CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size};
    CGRect visibleRect = CGRectInset(originalRect, -100, -100);
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behaviour, NSDictionary *bindings) {
        BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[[behaviour items] firstObject] indexPath]] != nil;
        return !currentlyVisible;
    }];
    NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:predicate];
    
    [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        [self.dynamicAnimator removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[[[obj items] firstObject] indexPath]];
    }];
    
    
    
    
    
    CGSize contentSize = self.collectionView.frame.size;
    NSArray *items = [super layoutAttributesForElementsInRect:
                      CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
    
    if (self.dynamicAnimator.behaviors.count == 0) {
        [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> obj, NSUInteger idx, BOOL *stop) {
            UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj
                                                                        attachedToAnchor:[obj center]];
            
            behaviour.length = 0.0f;
            behaviour.damping = 0.8f;
            behaviour.frequency = 1.0f;
            
            [self.dynamicAnimator addBehavior:behaviour];
        }];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

@end
