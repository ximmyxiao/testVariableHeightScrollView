//
//  VaribleHeightScrollView.m
//  testVariableHeightScrollView
//
//  Created by Piao Piao on 2017/2/24.
//  Copyright © 2017年 Piao Piao. All rights reserved.
//

#import "VaribleHeightScrollView.h"

@interface  VaribleHeightScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) NSArray* allPages;
@property(nonatomic,assign) NSInteger currentPage;
@end

@implementation VaribleHeightScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)commonInit
{
    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = self;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    NSLayoutConstraint* topConstraint = [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint* leadingConstraint = [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint* trailingConstraint = [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    NSLayoutConstraint* bottomConstraint = [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leadingConstraint];
    [self addConstraint:trailingConstraint];
    [self addConstraint:bottomConstraint];
    
    NSMutableArray* arrayTotal = [NSMutableArray array];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = 0;
    
    
    for (NSInteger i = 0 ; i < 4; i++)
    {
        UIView* subView = [UIView new];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayTotal addObject:subView];
    }
    self.allPages = [NSArray arrayWithArray:arrayTotal];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (void)setAllPages:(NSArray *)allPages
{
    [self.allPages makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _allPages = allPages;
    
    CGFloat xPos = 0;
    NSInteger i = 0;
    for (UIView* subView in self.allPages)
    {
        i++;
        xPos += subView.bounds.size.height;
        [self.scrollView addSubview:subView];
        CGFloat height = [[UIScreen mainScreen] bounds].size.height/2 + i%2*[[UIScreen mainScreen] bounds].size.height/2;
        NSLayoutConstraint* heightConstraint  = [subView.heightAnchor constraintEqualToConstant:height];
        [self.scrollView addConstraint:heightConstraint];
        NSLayoutConstraint* leadingConstraint = [subView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:xPos];
        NSLayoutConstraint* topConstraint = [subView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor];
        [self.scrollView addConstraint:leadingConstraint];
        [self.scrollView addConstraint:topConstraint];

    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)resetCurrentPage
{
    self.currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    NSLog(@"set page = %ld",self.currentPage);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetCurrentPage];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resetCurrentPage];
}

- (CGFloat) calcCurrentHeight
{
    
    CGFloat delta =  (self.scrollView.contentOffset.x - self.currentPage*self.scrollView.bounds.size.width)/self.scrollView.bounds.size.width;
    CGFloat currentPageHeight = ((UIView*)self.allPages[self.currentPage]).bounds.size.height;
    CGFloat nextPageHeight = 0;
    if (delta > 0)
    {
        nextPageHeight = ((UIView*)self.allPages[self.currentPage + 1]).bounds.size.height;
    }
    else if (delta < 0)
    {
        nextPageHeight = ((UIView*)self.allPages[self.currentPage - 1]).bounds.size.height;
    }
    else
    {
        return currentPageHeight;
    }
    
    CGFloat retHeight = currentPageHeight + (nextPageHeight - currentPageHeight)*fabs(delta);
    return retHeight;
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = [self calcCurrentHeight];
    return CGSizeMake(self.bounds.size.width, height);
}

@end
