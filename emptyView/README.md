集成tableView缺省页包括图片和文字功能


导入头文件
#import "ACEmptyViewHeader.h"
并设置缺省页：
    ACEmptyView*emptyView=[ACEmptyView emptyViewWithImageStr:@"noData" titleStr:@"Here is no datas."];
    self.tableView.AC_emptyView = emptyView;
效果如下图：




