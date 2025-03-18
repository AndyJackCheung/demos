集成tableView缺省页包括图片和文字功能


导入头文件
#import "ACEmptyViewHeader.h"

并设置缺省页：
    ACEmptyView*emptyView=[ACEmptyView emptyViewWithImageStr:@"noData" titleStr:@"Here is no datas."];
    self.tableView.AC_emptyView = emptyView;
    
效果如下图：



<img width="264" alt="截屏2025-03-18 10 59 38" src="https://github.com/user-attachments/assets/f1210374-856f-4d54-9194-1dbbfd274bdd" />

