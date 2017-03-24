# FMChannelEdit
这是一个类似“今日头条”频道编辑功能
## 前言
    站在巨人的肩膀上编程：这个项目是在两位前辈代码的基础上，进一步的修改，封装。
前辈一：codeWorm2015(GitHubID)
[源码地址](https://github.com/codeWorm2015/channelEdit.git)
前辈二：HelloYeah(GitHubID)
[源码地址](https://github.com/HelloYeah/DraggingSort.git)

PS：这两位具体是谁，我也不认识，想和他们具体交流的，请去GitHub上给他们留言，我这能帮你们到这了。
## 进入正题 （以下均为个人见解，理解不对还望见谅）
    之所以用着两位前辈的代码，是因为，虽然实现是同一UI效果，但是思路不同，下面一一讲解
### 方式一：(对应前辈一的实现思路)
         思路：完全自定义。自定义channelView（项目中名称：TouchView）继承于UIView,绑定需要的label，imageView，**pan,tap,longPress**手势，在对应的手势实现中计算出每个channel的index，然后刷新frame（具体实现请参考代码）
         优点：自定义程度高，自定义功能的添加修改比较方便，尤其动画比较流畅；
         缺点：要同时处理四个数组的数据（两个数据源的，两个视图的），frame刷新频率较高，且都是自己实现的frame刷新，性能可能不如原生的控件（只是可能）
         我的完善：原框架功能已经比较完善，只是缺少个下滑移除功能（已添加）
        GIF效果图：
        
### 方式二：(对应前辈二的实现思路)
         思路：在UICollectionView的基础上进一步的修改封装。（具体实现请参考代码）
         优点：只需要处理两个数据源就可以（上部&下部），视图由UICollectionView自己处理，包括动画效果也是系统自己完成；
         缺点：基于UICollectionView，功能的拓展受到一定的限制，动画不如方式一看这舒服。
         我的完善：原框架功能较少（相对于今日头条的channel编辑效果），只有上部分的排序和删除。（下部及其他功能已添加）
          
    

