集成tableView缺省页包括图片和文字功能


导入头文件
#import "ACEmptyViewHeader.h"

并设置缺省页：
    ACEmptyView*emptyView=[ACEmptyView emptyViewWithImageStr:@"noData" titleStr:@"Here is no datas."];
    self.tableView.AC_emptyView = emptyView;
    
效果如下图：




<img width="277" alt="截屏2025-03-18 10 51 30" src="https://github.com/user-attachments/assets/d0fc67b0-1527-4ca6-a0b9-68f0fd4ae5b9" />
