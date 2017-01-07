//
//  APGridLayoutScrollView.m
//  Demo

#import "APGridLayoutScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppView.h"

#define DELETE_BUTTON_EDGE_INSET    5



#define SELECT_BUTTON_IMAGE         @"checkbox_main_unchecked.png"

#define SELECTED_BUTTON_IMAGE         @"checkbox_checked.png"


#define DELETE_BUTTON_IMAGE         @"close.png"

#define DELETE_BUTTON_SIZE          16
#define TRASH_ICON_IMAGE            @"checkbox_checked.png"

#define WOBBLE_AMPLITUDE_GRID_VIEW      0.02f
#define WOBBLE_AMPLITUDE_DELETE_BUTTON  0.05f

#define DRAG_OUT_THRESHOLD           5.0f

static CGRect deleteButtonRawRect;

void clampValue(CGFloat* value, CGFloat min, CGFloat max)
{
    if (value)
    {
        if (*value > max)
        {
            *value = max;
        }
        if (*value < min)
        {
            *value = min;
        }
    }
}

void clampValueInt(int* value, int min, int max)
{
    if (value)
    {
        if (*value > max)
        {
            *value = max;
        }
        if (*value < min)
        {
            *value = min;
        }
    }
}

@implementation APGridLayoutDeleteButton

- (id)initWithSuperview:(CGSize)superViewSize layoutView:(APGridLayoutScrollView*)layoutView
{

    // 计算应该出现在view中的位置
    UIImage* image = [UIImage imageNamed:DELETE_BUTTON_IMAGE];
    
    CGSize size = CGSizeMake(DELETE_BUTTON_SIZE + 2 * DELETE_BUTTON_EDGE_INSET, DELETE_BUTTON_SIZE + 2 * DELETE_BUTTON_EDGE_INSET);
    const CGFloat AMEND = -3.0f;
    
    if (layoutView.deleteButtonPosition == APGridLayoutDeleteButtonTopRight)
    {
        deleteButtonRawRect.origin.x = layoutView.gridWidth - size.width + DELETE_BUTTON_EDGE_INSET + AMEND;
        deleteButtonRawRect.origin.y = -DELETE_BUTTON_EDGE_INSET - AMEND;
    }
    else if (layoutView.deleteButtonPosition == APGridLayoutDeleteButtonBottomLeft)
    {
        deleteButtonRawRect.origin.x = -DELETE_BUTTON_EDGE_INSET - AMEND;
        deleteButtonRawRect.origin.y = layoutView.gridHeight - size.height + DELETE_BUTTON_EDGE_INSET + AMEND;
    }
    else if (layoutView.deleteButtonPosition == APGridLayoutDeleteButtonBottomRight)
    {
        deleteButtonRawRect.origin.x = layoutView.gridWidth - size.width + DELETE_BUTTON_EDGE_INSET + AMEND;
        deleteButtonRawRect.origin.y = layoutView.gridHeight - size.height + DELETE_BUTTON_EDGE_INSET + AMEND;
    }
    else if (layoutView.deleteButtonPosition == APGridLayoutDeleteButtonCenter)
    {
        deleteButtonRawRect.origin.x = (layoutView.gridWidth - size.width) / 2.0f;
        deleteButtonRawRect.origin.y = (layoutView.gridHeight - size.height) / 2.0f;
    }
    else
    {
        // 默认为左上角
        deleteButtonRawRect.origin.x = -DELETE_BUTTON_EDGE_INSET - AMEND;
        deleteButtonRawRect.origin.y = -DELETE_BUTTON_EDGE_INSET - AMEND;
    }
    
    deleteButtonRawRect.size.width = size.width;
    deleteButtonRawRect.size.height = size.height;
    
    CGFloat viewX = (layoutView.gridWidth - superViewSize.width) / 2;
    CGFloat viewY = (layoutView.gridHeight - superViewSize.height) / 2;
    CGRect frame = CGRectMake(deleteButtonRawRect.origin.x - viewX, deleteButtonRawRect.origin.y - viewY, deleteButtonRawRect.size.width, deleteButtonRawRect.size.height);
    
    if (self = [super initWithFrame:frame])
    {
        [self setImageEdgeInsets:UIEdgeInsetsMake(DELETE_BUTTON_EDGE_INSET, DELETE_BUTTON_EDGE_INSET, DELETE_BUTTON_EDGE_INSET, DELETE_BUTTON_EDGE_INSET)];
        [self setImage:image forState:UIControlStateNormal];
    }
    
    return self;
}

+ (CGRect)deleteRectForSuperviewFrame:(CGRect)frame modification:(CGPoint)modification
{
    return CGRectMake(frame.origin.x + deleteButtonRawRect.origin.x + modification.x, frame.origin.y + deleteButtonRawRect.origin.y + modification.y, deleteButtonRawRect.size.width, deleteButtonRawRect.size.height);
}

@end

// 被拖拽的view上面盖一层，颜色深一些
@interface APGridLayoutSelectionMask : UIView

@end

@implementation APGridLayoutSelectionMask

@end

// 被拖到外面的即将删除的view，上面再添加一个垃圾筐的图标
@interface APGridLayoutTrashIcon : UIImageView

- (id)initWithFrame:(CGRect)frame;

@end

@implementation APGridLayoutTrashIcon

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImage* image = [UIImage imageNamed:TRASH_ICON_IMAGE];
        self.image = image;
        self.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    }
    
    return self;
}

@end

@interface UIView(APGridLayout)

- (APGridLayoutDeleteButton*)getDeleteButton;
- (void)addSelectionMask;
- (void)removeSelectionMask;

@end

@interface APGridLayoutDragHoverView : UIView

- (id)initWithView:(UIView*)hostView;

@end

@implementation APGridLayoutDragHoverView

- (id)initWithView:(UIView*)hostView
{
    // 显示hostView的截图内容
    if (self = [super initWithFrame:hostView.frame])
    {
        UIGraphicsBeginImageContextWithOptions(hostView.bounds.size, NO, 0.0);
        [hostView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* content = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView* hostImage = [[UIImageView alloc] initWithImage:content];
        hostImage.frame = self.bounds;
        hostImage.alpha = 0.5f;
        [self addSubview:hostImage];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end

@implementation UIView(APGridLayout)

- (APGridLayoutDeleteButton*)getDeleteButton
{
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[APGridLayoutDeleteButton class]])
        {
            return (APGridLayoutDeleteButton*)subView;
        }
    }
    
    return nil;
}

- (void)addSelectionMask
{
    APGridLayoutSelectionMask* mask = [[APGridLayoutSelectionMask alloc] initWithFrame:self.bounds];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.3f;
    [self addSubview:mask];
}

- (void)removeSelectionMask
{
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[APGridLayoutSelectionMask class]])
        {
            [subView removeFromSuperview];
            break;
        }
    }
}

- (void)addTrashIcon
{
    APGridLayoutTrashIcon* trashIcon = [[APGridLayoutTrashIcon alloc] initWithFrame:CGRectZero];
    trashIcon.center = CGPointMake(self.bounds.size.width - trashIcon.frame.size.width / 2 - 5, trashIcon.frame.size.height / 2 + 5);
    [self addSubview:trashIcon];
}

- (void)removeTrashIcon
{
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[APGridLayoutTrashIcon class]])
        {
            [subView removeFromSuperview];
            break;
        }
    }
}

- (void)addWobbleAnimation:(CGFloat)amplitude
{
    if (random() % 2 == 0)
    {
        amplitude = -amplitude;
    }
    
    CAKeyframeAnimation * anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = @[@(-amplitude), @0.0f, @(amplitude)];
    anim.autoreverses = YES;
    anim.repeatCount = NSUIntegerMax;
    anim.duration = 0.14f;
    [self.layer addAnimation:anim forKey:nil];
}

- (void)removeWobbleAnimation
{
    [self.layer removeAllAnimations];
}

@end
@interface APGridLayoutScrollView ()<AppViewActionDelegate>

@end
@implementation APGridLayoutScrollView

@synthesize style = _style;
@synthesize animatable = _animatable;
@synthesize editable = _editable;
@synthesize renormalizeSize = _renormalizeSize;
@synthesize alwaysShowHoverView = _alwaysShowHoverView;
@synthesize dragOutDeletion = _dragOutDeletion;
@synthesize dragOutOnEdgeDeletion = _dragOutOnEdgeDeletion;
@synthesize noWobbleOnDragging = _noWobbleOnDragging;
@synthesize deleteButtonPosition = _deleteButtonPosition;
@synthesize horizontalSplitImage = _horizontalSplitImage;
@synthesize verticalSplitImage = _verticalSplitImage;
@synthesize updateCount = _updateCount;
@synthesize columnCount = _columnCount;
@synthesize gridWidth = _gridWidth;
@synthesize gridHeight = _gridHeight;
@synthesize editing = _editing;
@synthesize gridViews = _gridViews;
@synthesize dataSource = _dataSource;
@synthesize gridContentView = _gridContentView;

- (id)initAsHorizontalLineStyleWithFrame:(CGRect)frame gridHeight:(CGFloat)gridHeight
{

    return [self initWithFrame:frame style:APGridLayoutStyleHorizontalInLine columnCount:1 gridWidth:0.0f gridHeight:gridHeight];
}

- (id)initAsVerticalLineStyleWithFrame:(CGRect)frame gridWidth:(CGFloat)gridWidth
{
    return [self initWithFrame:frame style:APGridLayoutStyleVerticalInLine columnCount:1 gridWidth:gridWidth gridHeight:0.0f];
}

- (id)initWithFrame:(CGRect)frame style:(APGridLayoutStyle)style columnCount:(NSUInteger)columnCount gridWidth:(CGFloat)gridWidth gridHeight:(CGFloat)gridHeight
{
    self = [super initWithFrame:frame];
    self.showsVerticalScrollIndicator = NO;
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _gridContentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_gridContentView];
        
        _splitViews = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_splitViews];
        
        _animatable = YES;
        _editable = YES;
        _alwaysShowHoverView = YES;
        _deleteButtonPosition = APGridLayoutDeleteButtonTopLeft;
        _gridViews = [[NSMutableArray alloc] initWithCapacity:40];
        
        _style = style;
        _gridWidth = gridWidth;
        _gridHeight = gridHeight;
        _columnCount = columnCount == 0 ? 1 : columnCount;
    }
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    if (_editing)
    {
        return self;
    }
    else
    {
        return view;
    }
}

- (CGRect)rectForGridViewAtIndex:(int)index
{
    // 返回第index个控件的格子在layoutView里的frame
    int row = index / _columnCount;
    int column = index % _columnCount;
    return CGRectMake(_gridWidth * column, _gridHeight * row, _gridWidth, _gridHeight);
}

- (void)gridViewCountChanged
{
    if (_style == APGridLayoutStyleHorizontalInLine)
    {
        _columnCount = [_gridViews count];
        _columnCount = _columnCount == 0 ? 1 : _columnCount;
        _gridWidth = self.frame.size.width / _columnCount;
    }
    else if (_style == APGridLayoutStyleVerticalInLine && [_gridViews count] > 0)
    {
        _gridHeight = self.frame.size.height / [_gridViews count];
    }
    
    [self setNeedsLayout];
}

- (void)addGridView:(UIView*)gridView
{
    AppView *appView = (AppView *)gridView;

    if ([_gridViews indexOfObject:appView] == NSNotFound)
    {
        appView.pressDelegate = self;
        
        [_gridViews addObject:appView];
        [self gridViewCountChanged];
    }
}

- (void)insertGridView:(UIView*)gridView at:(int)index
{
    NSUInteger currentIndex = [_gridViews indexOfObject:gridView];
    if (currentIndex != NSNotFound)
    {
        if (currentIndex != index)
        {
            [self moveGridView:gridView to:index];
        }
        else
        {
            [self setNeedsLayout];
        }
    }
    else if (index >= 0 && index <= [_gridViews count])
    {
        [_gridViews insertObject:gridView atIndex:index];
        [self gridViewCountChanged];
    }
}

- (void)removeGridView:(UIView*)gridView
{
    APGridLayoutDeleteButton *button = APGridLayoutDeleteButton.new;
    for (UIView *subView in gridView.subviews) {
        if ([subView isKindOfClass:[APGridLayoutDeleteButton class]]) {
            
            button = (APGridLayoutDeleteButton *)subView;
//            button.SELECTED = !button.SELECTED;
           
        }
    }
    switch (_buttonImage) {
        case APGridLayoutSelectButtonImg:
        {
            if (button.SELECTED) {
                [button setImage:[UIImage imageNamed:SELECTED_BUTTON_IMAGE] forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:SELECT_BUTTON_IMAGE] forState:UIControlStateNormal];
            }
           
        }
            break;
            
        default:{
            NSUInteger index = [_gridViews indexOfObject:gridView];
            if (index != NSNotFound)
            {
                [self removeGridViewAt:index];
            }
            [self endEdit];
        }
            break;
    }

}

- (void)removeGridViewAt:(NSUInteger)index
{
    if (index < [_gridViews count])
    {
        UIView* subView = [_gridViews objectAtIndex:index];
        [subView removeFromSuperview];
        [_gridViews removeObjectAtIndex:index];
        [self gridViewCountChanged];
    }
}

- (void)moveGridView:(UIView*)view to:(int)index
{
    NSUInteger currentIndex = [_gridViews indexOfObject:view];
    if (currentIndex != NSNotFound && ((int)currentIndex != index) && (index >= 0) && (index < [_gridViews count]))
    {
        [_gridViews removeObjectAtIndex:currentIndex];
        [self insertGridView:view at:index];
    }
}

- (void)updateGridViews:(NSMutableArray*)array
{
    for (UIView* view in _gridViews)
    {
        [view removeFromSuperview];
    }
    [_gridViews removeAllObjects];
    [_gridViews addObjectsFromArray:array];
    [self gridViewCountChanged];
}

- (void)removeAllGridViews
{
    [self updateGridViews:[NSMutableArray array]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_updateCount == 0)
    {
        CGFloat maxY = 0.0f;
        CGFloat x = _gridWidth / 2, y = _gridHeight / 2;
        
        while (_splitViews.subviews.count)
        {
            [[_splitViews.subviews lastObject] removeFromSuperview];
        }
        
        if (_animatable)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(layoutAnimationFinished)];
        }
        for (int i = 0; i < [_gridViews count]; i ++)
        {
            UIView* view = [_gridViews objectAtIndex:i];
            if (_renormalizeSize)
            {
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, _gridWidth, _gridHeight);
            }
            view.center = CGPointMake(x, y);
            
            if (y > maxY)
            {
                maxY = y;
            }
            
            if ((i + 1) % _columnCount == 0)
            {
                x = _gridWidth / 2;
                y += _gridHeight;
            }
            else
            {
                x += _gridWidth;
            }
        }
        if (_animatable)
        {
            [UIView commitAnimations];
        }
        
        CGSize contentSize = CGSizeMake(_gridWidth * _columnCount, maxY + _gridHeight / 2);
        _gridContentView.frame = CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height);
        for (UIView* view in _gridViews)
        {
            [_gridContentView addSubview:view];
        }
        if (_beingDraggedView)
        {
            [_beingDraggedView.superview bringSubviewToFront:_beingDraggedView];
        }
        self.contentSize = contentSize;
        
        // split views
        if (_horizontalSplitImage || _verticalSplitImage)
        {
            for (int i = 0; i < [_gridViews count]; i ++)
            {
                CGRect rect = [self rectForGridViewAtIndex:i];
                
                if (_horizontalSplitImage && ((i + 1) % _columnCount != 0))
                {
                    // 右边还有格子，需要分割线
                    UIImageView* split = [[UIImageView alloc] initWithImage:_horizontalSplitImage];
                    split.frame = CGRectMake(rect.origin.x + _gridWidth, rect.origin.y, _horizontalSplitImage.size.width, _horizontalSplitImage.size.height);
                    [_splitViews addSubview:split];
                }
                
                if (_verticalSplitImage && (i + _columnCount < [_gridViews count]))
                {
                    // 下边还有格子，需要分割线
                    UIImageView* split = [[UIImageView alloc] initWithImage:_verticalSplitImage];
                    split.frame = CGRectMake(rect.origin.x, rect.origin.y + _gridHeight, _verticalSplitImage.size.width, _verticalSplitImage.size.height);
                    [_splitViews addSubview:split];
                }
            }
        }
        
        if (!_animatable && _dataSource && [_dataSource respondsToSelector:@selector(onLayoutAnimationFinished:)])
        {
            [_dataSource onLayoutAnimationFinished:self];
        }
    }
}

- (void)layoutAnimationFinished
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(onLayoutAnimationFinished:)])
    {
        [_dataSource onLayoutAnimationFinished:self];
    }
}

- (void)beginUpdate
{
    _updateCount ++;
}

- (void)endUpdate
{
    _updateCount --;
    if (_updateCount == 0)
    {
        [self setNeedsLayout];
    }
}

- (void)setHorizontalSplitImage:(UIImage *)horizontalSplitImage
{
    _horizontalSplitImage = horizontalSplitImage;
    [self setNeedsLayout];
}

- (void)setVerticalSplitImage:(UIImage *)verticalSplitImage
{
    _verticalSplitImage = verticalSplitImage;
    [self setNeedsLayout];
}

#pragma mark -

- (CGPoint)deleteButtonModification
{
    return CGPointMake((_gridWidth - _initialGridWidth) / 2, (_gridHeight - _initialGridHeight) / 2);
}

- (void)restoreDragView
{
    UIView* _oldDraggedView = _beingDraggedView;
    self.scrollEnabled = YES;
    if (!_alwaysShowHoverView)
    {
        [_beingDraggedView removeSelectionMask];
    }
    _beingDraggedView = nil;
    [_deletingView getDeleteButton].highlighted = NO;
    _deletingView = nil;
    if (!_draggingHoverViewInAnimation)
    {
        [_draggingHoverView removeFromSuperview];
        _draggingHoverView = nil;
    }
    else
    {
        _draggingHoverShouldBeRemoved = YES;
    }
    [_dragScrollTimer invalidate];
    _dragScrollTimer = nil;
    [_dragOutTimer invalidate];
    _dragOutTimer = nil;
    _pendingDeletion = NO;
    
    if (_editing && _noWobbleOnDragging)
    {
        for (UIView* view in _gridViews)
        {
            [view addWobbleAnimation:WOBBLE_AMPLITUDE_GRID_VIEW];
        }
    }
    
    if (_oldDraggedView && _dataSource && [_dataSource respondsToSelector:@selector(onSubviewDragEnd:view:deleted:from:to:)])
    {
        NSUInteger currentIndex = [_gridViews indexOfObject:_oldDraggedView];
        [_dataSource onSubviewDragEnd:self view:_oldDraggedView deleted:currentIndex == NSNotFound from:_viewOriginalIndex to:(int)currentIndex];
    }
}

- (void)gridViewbeginEdit:(AppView *)appView longPress:(UILongPressGestureRecognizer *)sender {
    if (!_editing && _editable)
    {
        _editing = YES;
        [appView removeGestureRecognizer:sender];
        
        _initialGridWidth = _gridWidth;
        _initialGridHeight = _gridHeight;
        
        if (!_dragOutDeletion)
        {
            // 为子view添加删除按钮
            for (UIView* subView in _gridViews)
            {
                AppView *view = (AppView *)subView;
                

                if ([view.appId isEqualToString:@"more"]) return;
                if ([view.appId isEqualToString:appView.appId]){
                    
                    if (_dataSource && [_dataSource respondsToSelector:@selector(isSubviewDeletable:view:)] && ![_dataSource isSubviewDeletable:self view:view])
                    {
                        continue;
                    }
                    
                    view.userInteractionEnabled = NO;
                    APGridLayoutDeleteButton* delButton = [[APGridLayoutDeleteButton alloc] initWithSuperview:view.frame.size layoutView:self];
                     [delButton isSelectedState:NO];
                    switch (_buttonImage) {
                        case APGridLayoutSelectButtonImg:
                            [delButton setImage:[UIImage imageNamed:SELECT_BUTTON_IMAGE] forState:UIControlStateNormal];
                            break;

                        default :
                            [delButton setImage:[UIImage imageNamed:DELETE_BUTTON_IMAGE] forState:UIControlStateNormal];
                            break;
                    }
                    
                    [view addSubview:delButton];
                    
                };


            }
        }
        
        for (UIView* view in _gridViews)
        {
            [view addWobbleAnimation:WOBBLE_AMPLITUDE_GRID_VIEW];
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(onEditBegin:)])
        {
            [_dataSource onEditBegin:self];
        }
    }
}
- (void)beginEdit
{
    if (!_editing && _editable)
    {
        _editing = YES;
//        [self removeGestureRecognizer:_longPressGesture];
        
        
        _initialGridWidth = _gridWidth;
        _initialGridHeight = _gridHeight;
        
        if (!_dragOutDeletion)
        {
            // 为子view添加删除按钮
            for (UIView* gridView in _gridViews)
            {
                
                AppView *view = (AppView *)gridView;
                if ([view.appId isEqualToString:@"more"]) return;
                if (_dataSource && [_dataSource respondsToSelector:@selector(isSubviewDeletable:view:)] && ![_dataSource isSubviewDeletable:self view:view])
                {
                    continue;
                }
                
                view.userInteractionEnabled = NO;
                APGridLayoutDeleteButton* delButton = [[APGridLayoutDeleteButton alloc] initWithSuperview:view.frame.size layoutView:self];
                [delButton isSelectedState:NO];
                switch (_buttonImage) {
                    case APGridLayoutSelectButtonImg:
                    {
                        if (delButton.SELECTED) {
                            [delButton setImage:[UIImage imageNamed:SELECTED_BUTTON_IMAGE] forState:UIControlStateNormal];
                        }else{
                            [delButton setImage:[UIImage imageNamed:SELECT_BUTTON_IMAGE] forState:UIControlStateNormal];
                        }

                    }
                        break;
                        
                    default:
                        break;
                }
                [view addSubview:delButton];
            }
        }
        
        for (UIView* view in _gridViews)
        {
            if (self.animatable) {
               [view addWobbleAnimation:WOBBLE_AMPLITUDE_GRID_VIEW]; 
            }
            
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(onEditBegin:)])
        {
            [_dataSource onEditBegin:self];
        }
    }
}

- (void)endEdit
{
    if (_editing)
    {
        _editing = NO;
//        [self addGestureRecognizer:_longPressGesture];
        [self restoreDragView];
        
        if (!_dragOutDeletion)
        {
            for (UIView* view in _gridViews)
            {
                view.userInteractionEnabled = YES;
                [[view getDeleteButton] removeFromSuperview];
                [view removeWobbleAnimation];
            }
        }
        else
        {
            for (UIView* view in _gridViews)
            {
                [view removeWobbleAnimation];
            }
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(onEditEnd:)])
        {
            [_dataSource onEditEnd:self];
        }
    }
}

- (void)beginDragSubviewAt:(CGPoint)point
{
    if (_editing)
    {
        [self restoreDragView];
        self.scrollEnabled = NO;
        
        if (!_dragOutDeletion)
        {
            // 先检测是否按中的是删除按钮
            for (int i = 0; i < [_gridViews count]; i ++)
            {
                CGRect viewGridRect = [self rectForGridViewAtIndex:i];
                CGRect deleteRect = [APGridLayoutDeleteButton deleteRectForSuperviewFrame:viewGridRect modification:[self deleteButtonModification]];
                APGridLayoutDeleteButton* button = [_gridViews[i] getDeleteButton];
                if (button && CGRectContainsPoint(deleteRect, point))
                {
                    _deletingView = _gridViews[i];
                    button.highlighted = YES;
                    return;
                }
            }
        }

        // 按照从上到下的顺序搜索view，如果在其范围内则开始拖拽
        for (int i = (int)[_gridViews count] - 1; i >= 0; i --)
        {
            UIView* view = _gridViews[i];
            CGRect viewGridRect = [self rectForGridViewAtIndex:i];
            
            if (_dataSource && [_dataSource respondsToSelector:@selector(isSubviewDragable:view:)] && ![_dataSource isSubviewDragable:self view:view])
            {
                continue;
            }
            
            if (CGRectContainsPoint(viewGridRect, point))
            {
                _viewOriginalIndex = i;
                _dragAnchor = CGPointMake(point.x - view.frame.origin.x, point.y - view.frame.origin.y);
                _beingDraggedView = view;
                if (!_alwaysShowHoverView)
                {
                    [_beingDraggedView addSelectionMask]; // 如果拖动浮层总显示的话，就不在被拖动的view上添加一个阴影遮罩了
                }
                [_beingDraggedView.superview bringSubviewToFront:_beingDraggedView];
                
                _draggingHoverView = [[APGridLayoutDragHoverView alloc] initWithView:_beingDraggedView];
                [self relocateDragHoverView:NO];
                if (!_alwaysShowHoverView)
                {
                    _draggingHoverView.hidden = YES;
                }
                
                if (_noWobbleOnDragging)
                {
                    for (UIView* view in _gridViews)
                    {
                        [view removeWobbleAnimation];
                    }
                }
                else
                {
                    [_draggingHoverView addWobbleAnimation:WOBBLE_AMPLITUDE_GRID_VIEW];
                }
                
                if (_dataSource && [_dataSource respondsToSelector:@selector(onSubviewDragBegin:view:currentIndex:)])
                {
                    [_dataSource onSubviewDragBegin:self view:_beingDraggedView currentIndex:i];
                }

                return;
            }
        }
    }
    
    self.scrollEnabled = YES;
}

- (void)dragAutoscroll
{
    CGPoint offset = self.contentOffset;
    offset.x += _autoscrollX * _gridWidth;
    offset.y += _autoscrollY * _gridHeight;
    clampValue(&offset.x, 0.0f, self.contentSize.width - self.bounds.size.width);
    clampValue(&offset.y, 0.0f, self.contentSize.height - self.bounds.size.height);
    
    [UIView animateWithDuration:0.2f
                     animations:^ {
                         self.contentOffset = offset;
                     }
                     completion:^(BOOL finished) {
                         [self moveGridView:_beingDraggedView to:[self calculateInsertIndex:NO]];
                     }];
}

- (int)calculateInsertIndex:(BOOL)insert
{
    // 计算当前contentOffset下，把_beingDraggedView的_dragAnchor点拖动到_clampedPointToEdge位置，它会处在grid里的第几位
    CGPoint centerNow;
    centerNow.x = _clampedPointToEdge.x - (_dragAnchor.x + _beingDraggedView.frame.origin.x - _beingDraggedView.center.x) + self.contentOffset.x;
    centerNow.y = _clampedPointToEdge.y - (_dragAnchor.y + _beingDraggedView.frame.origin.y - _beingDraggedView.center.y) + self.contentOffset.y;
    
    clampValue(&centerNow.x, 1.0f, self.contentSize.width - 1.0f);
    clampValue(&centerNow.y, 1.0f, self.contentSize.height - 1.0f);
    
    // 计算centerNow在哪个格子里，这里要考虑_style和是否是插入状态，如果是horizontal或vertical，要用新的gridWidth和gridHeight
    CGFloat gw = _gridWidth;
    CGFloat gh = _gridHeight;
    NSUInteger gc = [_gridViews count] + (insert ? 1 : 0);
    NSUInteger cc = _columnCount;
    
    if (_style == APGridLayoutStyleHorizontalInLine)
    {
        cc = gc;
        cc = cc == 0 ? 1 : cc;
        gw = self.frame.size.width / cc;
    }
    else if (_style == APGridLayoutStyleVerticalInLine)
    {
        gh = self.frame.size.height / gc;
    }
    
    int rowCount = (int)gc / cc + (gc % cc == 0 ? 0 : 1);
    int row = (int)lrintf(floorf(centerNow.y / gh));
    clampValueInt(&row, 0, rowCount - 1);
    
    int column = centerNow.x / gw;
    clampValueInt(&column, 0, (int)cc - 1);
    
    int index = (int)(row * cc) + (int)column;
    clampValueInt(&index, 0, (int)gc);
    
    return index;
}

- (void)relocateDragHoverView:(BOOL)animate
{
    UIView* window = self.superview;
    while (![window isKindOfClass:[UIWindow class]])
    {
        window = window.superview;
    }
    
    if (animate)
    {
        _draggingHoverView.frame = [window convertRect:_beingDraggedView.frame fromView:self];
    }
    CGSize viewSize = _draggingHoverView.frame.size;
    CGPoint pointInWindow = [window convertPoint:_movePoint fromView:self];
    [window addSubview:_draggingHoverView];
    if (animate)
    {
        [UIView animateWithDuration:0.2f animations:^ {
            _draggingHoverView.frame = CGRectMake(pointInWindow.x - _dragAnchor.x, pointInWindow.y - _dragAnchor.y, viewSize.width, viewSize.height);
        }];
    }
    else
    {
        _draggingHoverView.frame = CGRectMake(pointInWindow.x - _dragAnchor.x, pointInWindow.y - _dragAnchor.y, viewSize.width, viewSize.height);
    }    
}

- (void)dragOutDeletionEvent
{
    _dragOutTimer = nil;
    [_dragScrollTimer invalidate];
    _dragScrollTimer = nil;
    
    // 将_beingDraggedView移出，进入在外部的拖拽状态，如果再次移动到self之内，再将其添加进来，如果用户在外面松开，则删除
    _pendingDeletion = YES;
    
    BOOL notDelete = _dataSource && [_dataSource respondsToSelector:@selector(isSubviewDeletable:view:)] && ![_dataSource isSubviewDeletable:self view:_beingDraggedView];
    if (!notDelete)
    {
        [_draggingHoverView addTrashIcon]; // 添加一个垃圾筐的图标
    }

    if (!_alwaysShowHoverView)
    {
        _draggingHoverView.hidden = NO;
        [self relocateDragHoverView:YES]; // 添加一个移动的动画
    }
    
    // 只是把_beingDraggedView从_gridViews移除，并且设置alpha为0，并不改变当前任何view结构，否则touch事件会乱掉，无法处理
    [_gridViews removeObject:_beingDraggedView];
    _originalAlpha = _beingDraggedView.alpha;
    _beingDraggedView.alpha = 0.0f;
    [self gridViewCountChanged];
}

- (void)restoreBeingDraggedViewAt:(int)index removeHover:(BOOL)removeHover
{    
    if (_moved)
    {
        // 如果移动过先把_beingDraggedView移动到当前hoverView被拖到的位置，这样再显示出来不会太突然
        _beingDraggedView.frame = CGRectMake(_movePoint.x - _dragAnchor.x, _movePoint.y - _dragAnchor.y, _beingDraggedView.frame.size.width, _beingDraggedView.frame.size.height);
    }

    _beingDraggedView.alpha = _originalAlpha;
    [self insertGridView:_beingDraggedView at:index];
    [self layoutIfNeeded];
    
    // 添加一个hoverView移动到grid正确位置的动画
    [_draggingHoverView removeTrashIcon];
    [UIView animateWithDuration:0.3f
                     animations:^ {
                         CGRect destRect = [self rectForGridViewAtIndex:index];
                         CGRect destRectForHover = [_draggingHoverView.superview convertRect:destRect fromView:self];
                         _draggingHoverViewInAnimation = YES;
                         _draggingHoverView.frame = destRectForHover;
                         _draggingHoverView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         _draggingHoverView.alpha = 1.0f;
                         if (!_alwaysShowHoverView)
                         {
                             _draggingHoverView.hidden = YES;
                         }
                         if (removeHover || _draggingHoverShouldBeRemoved)
                         {
                             [_draggingHoverView removeFromSuperview];
                             _draggingHoverView = nil;
                             _draggingHoverShouldBeRemoved = NO;
                         }
                         _draggingHoverViewInAnimation = NO;
                     }];
}

- (void)vanishHoverViewAnimated
{
    [UIView animateWithDuration:0.2f
                     animations:^ {
                         _draggingHoverViewInAnimation = YES;
                         _draggingHoverView.alpha = 0.0f;
                         CGAffineTransform t = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
                         _draggingHoverView.transform = CGAffineTransformScale(t, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                         _draggingHoverViewInAnimation = NO;
                         [_draggingHoverView removeFromSuperview];
                         _draggingHoverView = nil;
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editable)
    {
        return;
    }
    
    UITouch* touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    _movePoint = _touchPoint;
    _moved = NO;
    _initialTouch = YES;
    
    if (_editing)
    {
        // 已经是编辑状态，再次单击时检测子view，开始拖拽
        [self beginDragSubviewAt:_touchPoint];
    }
    else
    {
        _initialTouch = YES;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editable)
    {
        return;
    }
    
    _moved = YES;

    if (_editing)
    {
        UITouch* touch = [touches anyObject];
        _movePoint = [touch locationInView:self];
        
        if (_deletingView)
        {
            CGRect deleteRect = [APGridLayoutDeleteButton deleteRectForSuperviewFrame:_deletingView.frame modification:CGPointZero];
            [_deletingView getDeleteButton].highlighted = CGRectContainsPoint(deleteRect, _movePoint);
        }
        else if (_beingDraggedView)
        {
            _autoscrollX = 0;
            _autoscrollY = 0;
            _pointToEdge = CGPointMake(_movePoint.x - self.contentOffset.x, _movePoint.y - self.contentOffset.y);
            CGRect boundsRect = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
            
            [self relocateDragHoverView:NO];
            
            if (_pointToEdge.x < _gridWidth / 2)
            {
                _autoscrollX = -1;
            }
            else if (_pointToEdge.x > self.frame.size.width - _gridWidth / 2)
            {
                _autoscrollX = 1;
            }
            
            if (_pointToEdge.y < _gridHeight / 2)
            {
                _autoscrollY = -1;
            }
            else if (_pointToEdge.y > self.frame.size.height - _gridHeight / 2)
            {
                _autoscrollY = 1;
            }
            
            // 计算_beingDraggedView应该被拖动到的位置
            _clampedPointToEdge = _pointToEdge;
            clampValue(&_clampedPointToEdge.x, 0.0f, self.bounds.size.width);
            clampValue(&_clampedPointToEdge.y, 0.0f, self.bounds.size.height);
        
            if (_dragOutDeletion && _pendingDeletion)
            {
                // 如果view已经被拖到外面处于即将删除的状态，再拖动回来，需要重新加进去
                if (CGRectContainsPoint(boundsRect, _pointToEdge))
                {
                    _pendingDeletion = NO;
                    [self restoreBeingDraggedViewAt:[self calculateInsertIndex:YES] removeHover:NO]; // 恢复被拖动的view
                }
            }
            else
            {
                [self moveGridView:_beingDraggedView to:[self calculateInsertIndex:NO]]; // 重新放置拖动的view
            }
            
            if (!(_dragOutDeletion && _pendingDeletion) && (_autoscrollX != 0 || _autoscrollY != 0))
            {
                if (_dragScrollTimer == nil)
                {
                    // 拖动到scrollView边缘，需要自动滚动
                    _dragScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dragAutoscroll) userInfo:nil repeats:YES];
                }
            }
            else
            {
                [_dragScrollTimer invalidate];
                _dragScrollTimer = nil;
            }
            
            if (_dragOutDeletion && !_pendingDeletion)
            {
                // 如果是拖拽到外面删除的方式，需要一个延时再开启
                if (CGRectContainsPoint(boundsRect, _pointToEdge))
                {
                    [_dragOutTimer invalidate];
                    _dragOutTimer = nil;
                }
                else if (_dragOutOnEdgeDeletion)
                {
                    // 如果拖到外面松手立刻就删除，不用等待进入pending状态，则直接添加一个垃圾筐
                    [self dragOutDeletionEvent];
                }
                else if (_dragOutTimer == nil)
                {
                    _dragOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(dragOutDeletionEvent) userInfo:nil repeats:NO]; // 1秒后如果这个view还在外面，则将其移出，用户松开会会被删除
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editable)
    {
        return;
    }
    
    if (_editing)
    {
        UITouch* touch = [touches anyObject];
        CGPoint endPoint = [touch locationInView:self];
        
        if (_deletingView)
        {
            CGRect deleteRect = [APGridLayoutDeleteButton deleteRectForSuperviewFrame:_deletingView.frame modification:CGPointZero];
            if (CGRectContainsPoint(deleteRect, endPoint))
            {
                APGridLayoutDeleteButton *button = APGridLayoutDeleteButton.new;
                for (UIView *subView in _deletingView.subviews) {
                    if ([subView isKindOfClass:[APGridLayoutDeleteButton class]]) {
                        
                        button = (APGridLayoutDeleteButton *)subView;
                        button.SELECTED = !button.SELECTED;
                        
                    }
                }
                if (_dataSource && [_dataSource respondsToSelector:@selector(onSubviewDeleted:view:)])
                {
                    [_dataSource onSubviewDeleted:self view:_deletingView];
                }
                // 触发了删除操作
                [self removeGridView:_deletingView];

                [self restoreDragView];
               
            }
        }
        else if (_moved || _initialTouch)
        {
            _initialTouch = NO;
            
            if (_dragOutDeletion && _dragOutOnEdgeDeletion)
            {
                // 检测是否从边缘拖拽出去了，如果是则直接删除
                CGPoint pointToEdge = CGPointMake(endPoint.x - self.contentOffset.x, endPoint.y - self.contentOffset.y);
                if (pointToEdge.x < DRAG_OUT_THRESHOLD || pointToEdge.y < DRAG_OUT_THRESHOLD || pointToEdge.x > self.bounds.size.width - DRAG_OUT_THRESHOLD || pointToEdge.y > self.bounds.size.height - DRAG_OUT_THRESHOLD)
                {
                    // 检测这个view可否被删除
                    BOOL notDelete = _dataSource && [_dataSource respondsToSelector:@selector(isSubviewDeletable:view:)] && ![_dataSource isSubviewDeletable:self view:_beingDraggedView];
                    if (notDelete)
                    {
                        _pendingDeletion = NO;
                        [self restoreBeingDraggedViewAt:_viewOriginalIndex removeHover:YES]; // 恢复被拖动的view
                    }
                    else
                    {
                        if (_alwaysShowHoverView)
                        {
                            [self vanishHoverViewAnimated];
                        }
                        [self removeGridView:_beingDraggedView];
                        
                        if (_dataSource && [_dataSource respondsToSelector:@selector(onSubviewDeleted:view:)])
                        {
                            [_dataSource onSubviewDeleted:self view:_beingDraggedView];
                        }
                    }
                }
            }
            else if (_pendingDeletion)
            {
                [self vanishHoverViewAnimated];
                [_beingDraggedView removeFromSuperview];
                
                if (_dataSource)
                {
                    // 检测这个view可否被删除
                    if ([_dataSource respondsToSelector:@selector(isSubviewDeletable:view:)] && ![_dataSource isSubviewDeletable:self view:_beingDraggedView])
                    {
                        // 不可删除，恢复
                        [self restoreBeingDraggedViewAt:_viewOriginalIndex removeHover:YES];
                    }
                    else if ([_dataSource respondsToSelector:@selector(onSubviewDeleted:view:)])
                    {
                        [_dataSource onSubviewDeleted:self view:_beingDraggedView];
                    }
                }
            }

            [self restoreDragView];
        }
        else
        {
            // 编辑状态时，单击一下，没移动，则退出编辑状态
//            [self endEdit];
        }
    }
    
    _moved = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_editable)
    {
        return;
    }
    
    if (_editing)
    {
        if (_pendingDeletion)
        {
            // 如果将view拖拽出去，处于即将删除的状态，touch事件被取消，将view恢复，不执行删除
            [self restoreBeingDraggedViewAt:_viewOriginalIndex removeHover:YES];
        }
        
        [self restoreDragView];
    }
}

- (void)appView:(AppView *)appView didLongPressing:(UILongPressGestureRecognizer *)longPress{
    
    _longPressGesture = longPress;
    NSLog(@",appView.subviews -- %@",appView.subviews);
    
    switch (_buttonImage) {
        case APGridLayoutSelectButtonImg:
            
            break;
            
        default:{
            [self gridViewbeginEdit:appView longPress:longPress];

        }
            break;
    }
}
@end
