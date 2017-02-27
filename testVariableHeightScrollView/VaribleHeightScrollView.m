//
//  VaribleHeightScrollView.m
//  testVariableHeightScrollView
//
//  Created by Piao Piao on 2017/2/24.
//  Copyright © 2017年 Piao Piao. All rights reserved.
//

#import "VaribleHeightScrollView.h"


@interface VaribleScrollPageView()
@property(nonatomic,strong) UIImageView* imageView;
@end

@implementation VaribleScrollPageView

- (void)commonInit
{
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.imageView];
    
    NSLayoutConstraint* topConstraint = [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint* leadingConstraint = [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint* bottomConstraint = [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    NSLayoutConstraint* trailingConstraint = [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    
    [self addConstraint:topConstraint];
    [self addConstraint:leadingConstraint];
    [self addConstraint:bottomConstraint];
    [self addConstraint:trailingConstraint];

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
- (CGSize)intrinsicContentSize
{
    return self.image.size;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
}


@end

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
    self.backgroundColor = [UIColor clearColor];
    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
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
    CGFloat height = 0;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;

    

    for (NSInteger i = 0 ; i < 4; i++)
    {
        height = [[UIScreen mainScreen] bounds].size.height* 0.5*((i%2)*0.3 + 1);

        UIView* subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayTotal addObject:subView];
        
        NSLayoutConstraint* widthConstaint = [subView.widthAnchor constraintEqualToConstant:width];
        NSLayoutConstraint* heightConstraint = [subView.heightAnchor constraintEqualToConstant:height];
        
        
        [subView addConstraint:widthConstaint];
        [subView addConstraint:heightConstraint];
        
        if (i == 0)
        {
            subView.backgroundColor = [UIColor redColor];
        }
        else if (i== 1)
        {
            subView.backgroundColor = [UIColor blueColor];
            
        }
        else if (i == 2)
        {
            subView.backgroundColor = [UIColor blackColor];
            
        }
        else
        {
            subView.backgroundColor = [UIColor yellowColor];
            
        }
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
    CGFloat height = 0;
    for (UIView* subView in self.allPages)
    {
        i++;
        [self.scrollView addSubview:subView];



        NSLayoutConstraint* leadingConstraint = [subView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:xPos];
        NSLayoutConstraint* topConstraint = [subView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor];
        [self.scrollView addConstraint:leadingConstraint];
        [self.scrollView addConstraint:topConstraint];
        
        xPos += [UIScreen mainScreen].bounds.size.width;

        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*i, 0);
    }
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)resetCurrentPage
{
    self.currentPage = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    [self invalidateIntrinsicContentSize];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resetCurrentPage];
}

- (CGFloat) calcCurrentHeight
{
    
    CGFloat delta =  (self.scrollView.contentOffset.x - self.currentPage*[[UIScreen mainScreen] bounds].size.width)/[[UIScreen mainScreen] bounds].size.width;
    CGFloat currentPageHeight = ((UIView*)self.allPages[self.currentPage]).bounds.size.height;
    CGFloat nextPageHeight = 0;
    NSLog(@"delta:%f",delta);
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
    NSLog(@"scroll intrinsic height:%f",height);
    return CGSizeMake(self.bounds.size.width, height);
}



@end
