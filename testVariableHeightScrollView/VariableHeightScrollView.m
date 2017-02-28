//
//  VaribleHeightScrollView.m
//  testVariableHeightScrollView
//
//  Created by Piao Piao on 2017/2/24.
//  Copyright © 2017年 Piao Piao. All rights reserved.
//

#import "VariableHeightScrollView.h"

typedef NS_ENUM(NSInteger,PAGE_POSITION) {
    PAGE_IN_SCROLL_MIDDLE = 0,
    PAGE_IN_SCROLL_LEFT,
    PAGE_IN_SCROLL_RIGHT,
};

@interface VariableScrollPageView()
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,strong) UIImageView* imageView;
@property(nonatomic,strong) NSLayoutConstraint* leadingConstraint;
@property(nonatomic,strong) NSLayoutConstraint* trailingConstraint;
@property(nonatomic,strong) NSLayoutConstraint* rationConstraint;
@property(nonatomic,assign) PAGE_POSITION position;

@end

@implementation VariableScrollPageView

- (void)setPosition:(PAGE_POSITION)position
{
    NSLog(@"page :%ld, set to %ld",self.index,position);
    switch (position)
    {
        case PAGE_IN_SCROLL_MIDDLE:
        {
            [NSLayoutConstraint deactivateConstraints:@[self.rationConstraint]];
            [NSLayoutConstraint activateConstraints:@[self.leadingConstraint,self.trailingConstraint]];
//            self.rationConstraint.active = NO;
//            self.leadingConstraint.active = YES;
//            self.trailingConstraint.active = YES;
            break;
        }
        case PAGE_IN_SCROLL_LEFT:
        {
//            self.rationConstraint.active = YES;
//            self.leadingConstraint.active = NO;
//            self.trailingConstraint.active = YES;
            [NSLayoutConstraint deactivateConstraints:@[self.leadingConstraint]];
            [NSLayoutConstraint activateConstraints:@[self.rationConstraint,self.trailingConstraint]];
            break;
        }
        case PAGE_IN_SCROLL_RIGHT:
        {
//            self.rationConstraint.active = YES;
//            self.leadingConstraint.active = YES;
//            self.trailingConstraint.active = NO;
            [NSLayoutConstraint deactivateConstraints:@[self.trailingConstraint]];
            [NSLayoutConstraint activateConstraints:@[self.rationConstraint,self.leadingConstraint]];
            break;
        }
            
        default:
            break;
    }
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}
- (void)commonInit
{
    self.clipsToBounds = YES;
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    
    NSLayoutConstraint* topConstraint = [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor];
    self.leadingConstraint = [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint* bottomConstraint = [self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    self.trailingConstraint = [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];

    [self addConstraint:topConstraint];
    [self addConstraint:self.leadingConstraint];
    [self addConstraint:bottomConstraint];
    [self addConstraint:self.trailingConstraint];

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


- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
    
    CGSize size = [self pageSize];
    self.rationConstraint = [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor multiplier:size.width/size.height];
    [self.imageView addConstraint:self.rationConstraint];
    

}

- (CGSize)pageSize
{
    if (self.image)
    {
        CGFloat aspectRation = self.image.size.height/self.image.size.width;
        CGFloat desireHeight = aspectRation*(self.image.scale)*[UIScreen mainScreen].bounds.size.width;
        if (desireHeight > [UIScreen mainScreen].bounds.size.width*1.33)
        {
            desireHeight = [UIScreen mainScreen].bounds.size.width*1.33;
        }
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, desireHeight);
    }
    else
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width);
    }
}


@end

@interface  VariableHeightScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) NSArray* allPages;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) NSLayoutConstraint* selfHeightConstraint;
@end

@implementation VariableHeightScrollView

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

    

    for (NSInteger i = 0 ; i < 3; i++)
    {
        height = [[UIScreen mainScreen] bounds].size.height* 0.5*((i%2)*0.3 + 1);

        VariableScrollPageView* subView = [[VariableScrollPageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        subView.translatesAutoresizingMaskIntoConstraints = NO;
        [arrayTotal addObject:subView];
        subView.index = i;
        NSLayoutConstraint* widthConstaint = [subView.widthAnchor constraintEqualToConstant:width];
//        NSLayoutConstraint* heightConstraint = [subView.heightAnchor constraintEqualToConstant:height];
        
        
        [subView addConstraint:widthConstaint];
//        [subView addConstraint:heightConstraint];
        
        if (i == 0)
        {
            subView.image = [UIImage imageNamed:@"TEST_1"];
            subView.backgroundColor = [UIColor redColor];
        }
        else if (i== 1)
        {
            subView.image = [UIImage imageNamed:@"TEST_2.JPG"];
            subView.backgroundColor = [UIColor blueColor];
            
        }
        else if (i == 2)
        {
            subView.image = [UIImage imageNamed:@"TEST_3"];
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
    UIView* lastSubview = nil;
    CGFloat height = 0;
    for (VariableScrollPageView* subView in self.allPages)
    {
        i++;
        [self.scrollView addSubview:subView];


        
        NSLayoutConstraint* leadingConstraint = [subView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:xPos];
        if (lastSubview == nil)
        {
            leadingConstraint = [subView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:xPos];
        }
        else
        {
            leadingConstraint = [subView.leadingAnchor constraintEqualToAnchor:lastSubview.trailingAnchor];
        }
        
        lastSubview = subView;
        NSLayoutConstraint* topConstraint = [subView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor];
        NSLayoutConstraint* heightConstraint = [subView.heightAnchor constraintEqualToAnchor:self.heightAnchor];
        [self.scrollView addConstraint:leadingConstraint];
        [self.scrollView addConstraint:topConstraint];
        [self addConstraint:heightConstraint];
        
        CGSize pageSize = [subView pageSize];
        NSLayoutConstraint* ratioConstraint = [subView.widthAnchor constraintEqualToAnchor:subView.heightAnchor multiplier:pageSize.width/pageSize.height];
//        [subView addConstraint:ratioConstraint];
//        xPos += [UIScreen mainScreen].bounds.size.width;

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
    CGFloat nextPageHeight = 0;
    NSLog(@"delta:%f",delta);
    CGFloat retHeight = 0;
    VariableScrollPageView* currentPage = ((VariableScrollPageView*)self.allPages[self.currentPage]);
    CGFloat currentPageHeight = [currentPage pageSize].height;

    if (delta > 0)
    {
        VariableScrollPageView* pageToShow = ((VariableScrollPageView*)self.allPages[self.currentPage + 1]);
        [pageToShow setPosition:PAGE_IN_SCROLL_RIGHT];
        [currentPage setPosition:PAGE_IN_SCROLL_LEFT];

        nextPageHeight = [pageToShow pageSize].height;
    }
    else if (delta < 0)
    {
        VariableScrollPageView* pageToShow = ((VariableScrollPageView*)self.allPages[self.currentPage - 1]);
        [pageToShow setPosition:PAGE_IN_SCROLL_LEFT];
        [currentPage setPosition:PAGE_IN_SCROLL_RIGHT];

        nextPageHeight = [pageToShow pageSize].height;
    }
    else
    {
        nextPageHeight = currentPageHeight;
        for (VariableScrollPageView* page in self.allPages)
        {
            [page setPosition:PAGE_IN_SCROLL_MIDDLE];

        }
    }
    
    
    
    retHeight = currentPageHeight + (nextPageHeight - currentPageHeight)*fabs(delta);
    

    return retHeight;
}

- (CGSize)intrinsicContentSize
{
    [self removeConstraint:self.selfHeightConstraint];
    CGFloat height = [self calcCurrentHeight];
    NSLog(@"scroll intrinsic height:%f",height);

    
    self.selfHeightConstraint = [self.heightAnchor constraintEqualToConstant:height];
    [self addConstraint:self.selfHeightConstraint];
    return CGSizeMake(self.bounds.size.width, height);
}



@end
