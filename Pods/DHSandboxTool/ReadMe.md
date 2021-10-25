# 沙盒工具使用介绍

## 1、简介
### 1.1 工具地址
`https://yfgitlab.dahuatech.com/PublicCloud/APP-Com/ios-libs/DHSandboxTool`

### 1.2 功能介绍



![Alt text](./Doc/一级目录.png)

![Alt text](./Doc/二级.png)

![Alt text](./Doc/FileOperation.png)

![Alt text](./Doc/Delete.png)

#### 1.2.1 目录/文件名展示
* 目录展示：支持多级目录展示、返回上一级
* 文件展示：支持文件展示


#### 1.2.2 目录/文件大小展示
自动适配 B/KB/MB显示
* 目录：展示目录的总大小
* 文件：展示文件大小

#### 1.2.3 文件分享
使用系统自带的分享控件，支持AirDrop、微信等。


#### 1.2.4 文件预览
使用系统自带的预览控件，对于不支持的文件类型，提示不支持预览。

#### 1.2.5 目录/文件删除
支持目录/文件的侧滑单个删除
> 注意：一级目录及一级目录下的文件不能删除




## 2、集成
使用`cocoapods`

### 2.1 集成方式
主工程`Podfile`中，参考添加：

```
source 'https://yfgitlab.dahuatech.com/PublicCloud/APP-Com/LCPrivateCocoaPods'
```

```
pod 'DHSandboxTool'
```




### 2.2 子工程中引用

需要在子工程的`FRAMEWORK_SEARCH_PATHS`中添加`DHSandBox`的生成路径
```
$(POD_SEARCH_FRAMEWORK_PATH)/DHSandboxTool
```

`POD_SEARCH_FRAMEWORK_PATH`配置为
```
${BUILD_DIR}/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)
```


## 3、代码适配

*  引入`DHSandboxTool`
*  未使用`DHNavigationController`跳转的，直接引用`DHSandBoxViewController`类即可
*  使用`DHNavigationController`跳转的，需要上层作为childController或直接添加view使用

```
import DHSandboxTool

 private func openSandboxTool() {
	 let sandboxVc = DHSandBoxViewController() 
     navigationController?.pushViewController(sandboxVc, animated: true)
 }



//MARK: SandboxTool
class DHSandboxDebugViewController: DHBaseViewController {
    var childSandboxVc: DHSandBoxViewController = DHSandBoxViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(childSandboxVc)
        view.addSubview(childSandboxVc.view)
        childSandboxVc.view.frame = view.bounds
    }
}

```