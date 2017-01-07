//
//  APGridLayoutScrollView.h
//  Demo

#import <UIKit/UIKit.h>

@class APGridLayoutScrollView;

@interface APGridLayoutDeleteButton : UIButton

- (id)initWithSuperview:(CGSize)superViewSize layoutView:(APGridLayoutScrollView*)layoutView;
+ (CGRect)deleteRectForSuperviewFrame:(CGRect)frame modification:(CGPoint)modification;
@property (nonatomic ,assign,setter=isSelectedState:)Boolean SELECTED;

@end

@protocol APGridLayoutScrollViewDelegate <NSObject>

@optional

- (void)onLayoutAnimationFinished:(APGridLayoutScrollView*)sender;
- (void)onEditBegin:(APGridLayoutScrollView*)sender;
- (void)onEditEnd:(APGridLayoutScrollView*)sender;
- (BOOL)isSubviewDragable:(APGridLayoutScrollView*)sender view:(UIView*)view; // 默认YES，view能否被主动拖拽，因其它view位置变动而导致这个view位置变动不算
- (BOOL)isSubviewDeletable:(APGridLayoutScrollView*)sender view:(UIView*)view; // 默认YES
- (void)onSubviewDeleted:(APGridLayoutScrollView*)sender view:(UIView*)view;
- (void)onSubviewDragBegin:(APGridLayoutScrollView*)sender view:(UIView*)view currentIndex:(int)currentIndex;
- (void)onSubviewDragEnd:(APGridLayoutScrollView*)sender view:(UIView*)view deleted:(BOOL)deleted from:(int)from to:(int)to;

@end

typedef NS_ENUM(NSInteger, APGridLayoutStyle)
{
    APGridLayoutStyleDefault,               // 默认风格，指定columnCount和gridWidth、gridHeight，网格状显示
    APGridLayoutStyleHorizontalInLine,      // 横向一行风格，不需要指定columnCount，所有gridView显示在一行里，并且gridWidth = self.frame.size.width / 对象个数
    APGridLayoutStyleVerticalInLine,        // 纵向一列风格，不需要指定columnCount，gridHeight = self.frame.size.height / 对象个数
};

typedef NS_ENUM(NSInteger, APGridLayoutDeleteButtonPosition)
{
    APGridLayoutDeleteButtonTopLeft,
    APGridLayoutDeleteButtonTopRight,
    APGridLayoutDeleteButtonBottomLeft,
    APGridLayoutDeleteButtonBottomRight,
    APGridLayoutDeleteButtonCenter,
};

typedef NS_ENUM(NSInteger, APGridLayoutButtonImage)
{
    APGridLayoutDeleteButtonImg,

    APGridLayoutSelectButtonImg,
};

@interface APGridLayoutScrollView : UIScrollView
{
    UIView* _gridContentView;
    UIView* _splitViews;    // 当horizontalSplitImage或verticalSplitImage有效
    int _updateCount;
    NSUInteger _columnCount; // 纵向有多少列
    CGFloat _gridWidth;
    CGFloat _gridHeight;
    CGFloat _initialGridWidth;
    CGFloat _initialGridHeight;
    
    NSMutableArray* _gridViews;
    
    UILongPressGestureRecognizer* _longPressGesture;
    
    APGridLayoutStyle _style;
    BOOL _animatable;
    BOOL _editable;
    BOOL _renormalizeSize;
    BOOL _alwaysShowHoverView;
    BOOL _dragOutDeletion;
    BOOL _dragOutOnEdgeDeletion; 
    BOOL _noWobbleOnDragging;
    APGridLayoutDeleteButtonPosition _deleteButtonPosition;
    UIImage* _horizontalSplitImage;
    UIImage* _verticalSplitImage;
    
    BOOL _editing;
    BOOL _moved;
    BOOL _initialTouch;
    BOOL _pendingDeletion; // view已经被拖到外面，进入即将删除的状态
    BOOL _draggingHoverViewInAnimation;
    BOOL _draggingHoverShouldBeRemoved;
    int _viewOriginalIndex;
    CGFloat _originalAlpha; // 被拖到外面即将删除的view的原始alpha
    CGPoint _touchPoint, _dragAnchor, _movePoint, _pointToEdge, _clampedPointToEdge;
    UIView* _beingDraggedView;
    UIView* _deletingView;
    UIView* _draggingHoverView; // 拖到外面后代替被拖动的view显示在window里的view
    
    int _autoscrollX, _autoscrollY; // 拖动时碰到scrollView的边缘，自动滚动的参数
    NSTimer *_dragScrollTimer, *_dragOutTimer;
    
    __weak id<APGridLayoutScrollViewDelegate> _dataSource;
}

@property (nonatomic, readonly) APGridLayoutStyle style;              // 默认为APGridLayoutStyleDefault
@property (nonatomic) BOOL animatable;                      // 排版时是否有动画效果
@property (nonatomic) BOOL editable;                        // 是否可编辑，默认为YES
@property (nonatomic) BOOL renormalizeSize;                 // 是否把gridViews的尺寸重新标准化
@property (nonatomic) BOOL alwaysShowHoverView;             // 默认为YES，是否拖拽时总显示一个半透明的被拖拽的view的截图。如果为NO，则在删除按钮模式下，拖拽不显示任何hoverView，在拖拽到外面删除的模式下只有拖到外面处于即将删除的状态才显示hoverView
@property (nonatomic) BOOL dragOutDeletion;                 // 是否采用拖动出scrollView范围就删除的方式，如果为NO，使用删除按钮的方式
@property (nonatomic) BOOL dragOutOnEdgeDeletion;           // 是否支持拖到边缘松手就删除，需要在dragOutDeletion模式下才有效
@property (nonatomic) BOOL noWobbleOnDragging;              // dragOutDeletion模式下，拖拽时是否取消抖动
@property (nonatomic) APGridLayoutDeleteButtonPosition deleteButtonPosition;    // 删除按钮的位置，默认为APGridLayoutDeleteButtonTopLeft
@property (nonatomic) APGridLayoutButtonImage buttonImage;    // 删除按钮的位置，默认为APGridLayoutDeleteButtonTopLeft
@property (nonatomic, strong) UIImage* horizontalSplitImage;
@property (nonatomic, strong) UIImage* verticalSplitImage;
@property (nonatomic, readonly) int updateCount;
@property (nonatomic, readonly) NSUInteger columnCount;
@property (nonatomic, readonly) CGFloat gridWidth;
@property (nonatomic, readonly) CGFloat gridHeight;
@property (nonatomic, readonly) BOOL editing;
@property (nonatomic, readonly) NSArray* gridViews;
@property (nonatomic, readonly) UIView* gridContentView;    // gridView的直接parent也就是_content，有时希望往APGridLayoutScrollView里添加一些gridView，再添加一些不参与排版的控件。那么那些控件就会处于所有gridView的上面，因为它处于_content的上面。提供这个可以进行修改
@property (nonatomic, weak) id<APGridLayoutScrollViewDelegate> dataSource;

- (id)initAsHorizontalLineStyleWithFrame:(CGRect)frame gridHeight:(CGFloat)gridHeight;
- (id)initAsVerticalLineStyleWithFrame:(CGRect)frame gridWidth:(CGFloat)gridWidth;
- (id)initWithFrame:(CGRect)frame style:(APGridLayoutStyle)style columnCount:(NSUInteger)columnCount gridWidth:(CGFloat)gridWidth gridHeight:(CGFloat)gridHeight;

- (void)addGridView:(UIView*)gridView;
- (void)insertGridView:(UIView*)gridView at:(int)index;
- (void)removeGridView:(UIView*)gridView;
- (void)removeGridViewAt:(NSUInteger)index;
- (void)moveGridView:(UIView*)view to:(int)index;
- (void)updateGridViews:(NSMutableArray*)array;
- (void)removeAllGridViews;

- (void)beginUpdate;
- (void)endUpdate;

- (void)beginEdit;
- (void)endEdit;

@end
