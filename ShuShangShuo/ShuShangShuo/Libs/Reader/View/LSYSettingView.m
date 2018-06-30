//
//  LSYSettingView.m
//  ShuShangShuo
//
//  Created by zhangzey on 08/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "LSYSettingView.h"
#import "LSYMenuView.h"

@interface LSYSettingView ()

@property (nonatomic, strong) UIImageView *nightModeImgView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic, strong) UIImageView *dayModeImgView;
@property (nonatomic,strong) UIButton *curlTransitionBtn;
@property (nonatomic,strong) UIButton *scrollTransitionBtn;
@property (nonatomic,strong) UIButton *increaseFont;
@property (nonatomic,strong) UIButton *decreaseFont;
@property (nonatomic,strong) UILabel *fontLabel;
@property (nonatomic,strong) UIButton *increaseLineSpace;
@property (nonatomic,strong) UIButton *decreaseLineSpace;
@property (nonatomic,strong) UILabel *lineSpaceLabel;
@property (nonatomic,strong) LSYThemeView *themeView;

@end

@implementation LSYSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [[LSYReadConfig shareInstance] addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
        [[LSYReadConfig shareInstance] addObserver:self forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.nightModeImgView];
    [self addSubview:self.dayModeImgView];
    [self addSubview:self.slider];
    [self addSubview:self.curlTransitionBtn];
    [self addSubview:self.scrollTransitionBtn];
    [self addSubview:self.increaseFont];
    [self addSubview:self.decreaseFont];
    [self addSubview:self.fontLabel];
    [self addSubview:self.increaseLineSpace];
    [self addSubview:self.decreaseLineSpace];
    [self addSubview:self.lineSpaceLabel];
    [self addSubview:self.themeView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nightModeImgView.frame = CGRectMake(30, 20, 16, 16);
    self.dayModeImgView.frame = CGRectMake(self.width - 30 - 16, 20, 16, 16);
    CGFloat sliderX = self.nightModeImgView.right+10;
    self.slider.frame = CGRectMake(self.nightModeImgView.right+10, 0, self.dayModeImgView.x - sliderX - 10, 30);
    self.slider.centerY = self.nightModeImgView.centerY;
    
    self.decreaseFont.frame = CGRectMake(self.nightModeImgView.x, self.slider.bottom + 10, 40, 30);
    self.fontLabel.frame = CGRectMake(self.decreaseFont.right, self.slider.bottom + 10, 50, 30);
    self.increaseFont.frame = CGRectMake(self.fontLabel.right, self.slider.bottom + 10,  40, 30);
    
    self.decreaseLineSpace.frame = CGRectMake(self.increaseFont.right + 30, self.slider.bottom + 10,  40, 30);
    self.lineSpaceLabel.frame = CGRectMake(self.decreaseLineSpace.right, self.slider.bottom + 10, 50, 30);
    self.increaseLineSpace.frame = CGRectMake(self.lineSpaceLabel.right, self.slider.bottom + 10, 40, 30);
    
    self.curlTransitionBtn.frame = CGRectMake(self.slider.x, self.decreaseFont.bottom + 20, 50, 35);
    self.scrollTransitionBtn.frame = CGRectMake(self.slider.right - 50, self.decreaseFont.bottom + 20, 50, 35);
    self.themeView.frame = CGRectMake(0, self.curlTransitionBtn.bottom+20, self.width, 40);
}

-(UIImage *)thumbImage {
    CGRect rect = CGRectMake(0, 0, 15,15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:7.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    {
        [[UIColor whiteColor] setFill];
        [path fill];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

-(void)changeFont:(UIButton *)sender {
    if (sender == _increaseFont) {

        if (floor([LSYReadConfig shareInstance].fontSize) == floor(MaxFontSize)) {
            return;
        }
        [LSYReadConfig shareInstance].fontSize++;
    }
    else{
        if (floor([LSYReadConfig shareInstance].fontSize) == floor(MinFontSize)){
            return;
        }
        [LSYReadConfig shareInstance].fontSize--;
    }
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize)]) {
        [self.delegate menuViewFontSize];
    }
}

-(void)changeLineSpace:(UIButton *)sender {
    if (sender == _increaseLineSpace) {
        
        [LSYReadConfig shareInstance].lineSpace++;
    }
    else{
        [LSYReadConfig shareInstance].lineSpace--;
    }
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize)]) {
        [self.delegate menuViewFontSize];
    }
}

- (void)curlTransitionBtnClick {
    if ([self.delegate respondsToSelector:@selector(changeTransitionStyle:)]) {
        [self.delegate changeTransitionStyle:UIPageViewControllerTransitionStylePageCurl];
    }
}

- (void)scrollTransitionBtnClick {
    if ([self.delegate respondsToSelector:@selector(changeTransitionStyle:)]) {
        [self.delegate changeTransitionStyle:UIPageViewControllerTransitionStyleScroll];
    }
}

- (void)sliderValueChange:(UISlider *)sender {
    double value1 = 1.0-sender.value;
    if ([self.delegate respondsToSelector:@selector(changeMaskViewLight:)]) {
        [self.delegate changeMaskViewLight:value1];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fontSize"]){
        _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[LSYReadConfig shareInstance].fontSize];
    }
    
    if ([keyPath isEqualToString:@"lineSpace"]) {
        _lineSpaceLabel.text = [NSString stringWithFormat:@"%d",(int)[LSYReadConfig shareInstance].lineSpace];
    }
}

- (UIImageView *)nightModeImgView {
    if(!_nightModeImgView) {
        _nightModeImgView = [[UIImageView alloc]init];
        _nightModeImgView.image = IMAGENAMED(@"reader_moon");
    }
    return _nightModeImgView;
}

- (UIImageView *)dayModeImgView {
    if(!_dayModeImgView) {
        _dayModeImgView = [[UIImageView alloc]init];
        _dayModeImgView.image = IMAGENAMED(@"reader_sun");
    }
    return _dayModeImgView;
}

-(UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.minimumTrackTintColor = OrangeThemeColor;
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        _slider.value = 1;
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateNormal];
        [_slider setThumbImage:[self thumbImage] forState:UIControlStateHighlighted];
        [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [_slider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
    }
    return _slider;
}

- (UIButton *)curlTransitionBtn {
    if (!_curlTransitionBtn) {
        _curlTransitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_curlTransitionBtn setTitle:@"仿真" forState:UIControlStateNormal];
        _curlTransitionBtn.titleLabel.font = Font(14);
        _curlTransitionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _curlTransitionBtn.layer.borderWidth = 1.f;
        _curlTransitionBtn.layer.cornerRadius = 5;
        [_curlTransitionBtn addTarget:self action:@selector(curlTransitionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _curlTransitionBtn;
}

- (UIButton *)scrollTransitionBtn
{
    if (!_scrollTransitionBtn) {
        _scrollTransitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollTransitionBtn setTitle:@"滑动" forState:UIControlStateNormal];
        _scrollTransitionBtn.titleLabel.font = Font(14);
        _scrollTransitionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _scrollTransitionBtn.layer.borderWidth = 1.f;
        _scrollTransitionBtn.layer.cornerRadius = 5;
        [_scrollTransitionBtn addTarget:self action:@selector(scrollTransitionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scrollTransitionBtn;
}

-(UIButton *)increaseFont
{
    if (!_increaseFont) {
        _increaseFont = [LSYReadUtilites commonButtonSEL:@selector(changeFont:) target:self];
        [_increaseFont setTitle:@"A+" forState:UIControlStateNormal];
        [_increaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _increaseFont.layer.borderWidth = 1;
        _increaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _increaseFont;
}
-(UIButton *)decreaseFont
{
    if (!_decreaseFont) {
        _decreaseFont = [LSYReadUtilites commonButtonSEL:@selector(changeFont:) target:self];
        [_decreaseFont setTitle:@"A-" forState:UIControlStateNormal];
        [_decreaseFont.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _decreaseFont.layer.borderWidth = 1;
        _decreaseFont.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _decreaseFont;
}
-(UILabel *)fontLabel
{
    if (!_fontLabel) {
        _fontLabel = [[UILabel alloc] init];
        _fontLabel.font = [UIFont systemFontOfSize:14];
        _fontLabel.textColor = [UIColor whiteColor];
        _fontLabel.textAlignment = NSTextAlignmentCenter;
        _fontLabel.text = [NSString stringWithFormat:@"%d",(int)[LSYReadConfig shareInstance].fontSize];
    }
    return _fontLabel;
}

-(UIButton *)increaseLineSpace
{
    if (!_increaseLineSpace) {
        _increaseLineSpace = [LSYReadUtilites commonButtonSEL:@selector(changeLineSpace:) target:self];
        [_increaseLineSpace setTitle:@"L+" forState:UIControlStateNormal];
        [_increaseLineSpace.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _increaseLineSpace.layer.borderWidth = 1;
        _increaseLineSpace.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _increaseLineSpace;
}
-(UIButton *)decreaseLineSpace
{
    if (!_decreaseLineSpace) {
        _decreaseLineSpace = [LSYReadUtilites commonButtonSEL:@selector(changeLineSpace:) target:self];
        [_decreaseLineSpace setTitle:@"L-" forState:UIControlStateNormal];
        [_decreaseLineSpace.titleLabel setFont:[UIFont systemFontOfSize:17]];
        _decreaseLineSpace.layer.borderWidth = 1;
        _decreaseLineSpace.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _decreaseLineSpace;
}
-(UILabel *)lineSpaceLabel
{
    if (!_lineSpaceLabel) {
        _lineSpaceLabel = [[UILabel alloc] init];
        _lineSpaceLabel.font = [UIFont systemFontOfSize:14];
        _lineSpaceLabel.textColor = [UIColor whiteColor];
        _lineSpaceLabel.textAlignment = NSTextAlignmentCenter;
        _lineSpaceLabel.text = [NSString stringWithFormat:@"%d",(int)[LSYReadConfig shareInstance].lineSpace];
    }
    return _lineSpaceLabel;
}

-(LSYThemeView *)themeView
{
    if (!_themeView) {
        _themeView = [[LSYThemeView alloc] init];
        _themeView.settingView = self;
    }
    return _themeView;
}

/*3.移除通知*/
-(void)dealloc{
    [_slider removeObserver:self forKeyPath:@"highlighted"];
    [[LSYReadConfig shareInstance] removeObserver:self forKeyPath:@"fontSize"];
    [[LSYReadConfig shareInstance] removeObserver:self forKeyPath:@"lineSpace"];
}

@end

@interface LSYThemeView ()
@property (nonatomic,strong) UIView *theme1;
@property (nonatomic,strong) UIView *theme2;
@property (nonatomic,strong) UIView *theme3;
@end
@implementation LSYThemeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.theme1];
    [self addSubview:self.theme2];
    [self addSubview:self.theme3];
}
-(UIView *)theme1
{
    if (!_theme1) {
        _theme1 = [[UIView alloc] init];
        _theme1.backgroundColor = [UIColor whiteColor];
        [_theme1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme1;
}
-(UIView *)theme2
{
    if (!_theme2) {
        _theme2 = [[UIView alloc] init];
        _theme2.backgroundColor = [UIColor colorWithHexString:@"BCB2BE"];
        [_theme2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme2;
}
-(UIView *)theme3
{
    if (!_theme3) {
        _theme3 = [[UIView alloc] init];
        _theme3.backgroundColor = [UIColor colorWithHexString:@"BEB6A2"];
        [_theme3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeTheme:)]];
    }
    return _theme3;
}
-(void)changeTheme:(UITapGestureRecognizer *)tap
{
    if ([tap.view.backgroundColor isEqual:[UIColor whiteColor]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModeChange" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LSYThemeNotification object:tap.view.backgroundColor];
}
-(void)layoutSubviews
{
    CGFloat spacing = (self.width-40*3)/4;
    _theme1.frame = CGRectMake(spacing, 0, 40, 40);
    _theme2.frame = CGRectMake(DistanceFromLeftGuiden(_theme1)+spacing, 0, 40, 40);
    _theme3.frame = CGRectMake(DistanceFromLeftGuiden(_theme2)+spacing, 0, 40, 40);
}
@end
