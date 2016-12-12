# Perfect HTTP 请求日志  [English](README.md)


<p align="center">
<a href="http://perfect.org/get-involved.html" target="_blank">
<img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
</a>
</p>

<p align="center">
<a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
</a>  
<a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
<img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
</a>  
<a href="https://twitter.com/perfectlysoft" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
</a>  
<a href="http://perfect.ly" target="_blank">
<img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
</a>
</p>

<p align="center">
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
</a>
<a href="https://developer.apple.com/swift/" target="_blank">
<img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
</a>
<a href="http://perfect.org/licensing.html" target="_blank">
<img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
</a>
<a href="http://twitter.com/PerfectlySoft" target="_blank">
<img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
</a>
<a href="http://perfect.ly" target="_blank">
<img src="http://perfect.ly/badge.svg" alt="Slack Status">
</a>
</p>

本项目是Perfect —— Swift 服务器端软件框架的一个组成部分，用于HTTP请求对象的日志记录，采用SPM软件包管理器进行编译和运行、测试。

## 日志输出样本

```
[INFO] [62f940aa-f204-43ed-9934-166896eda21c] [servername/WuAyNIIU-1] 2016-10-07 21:49:04 +0000 "GET /one HTTP/1.1" from 127.0.0.1 - 200 64B in 0.000436007976531982s
[INFO] [ec6a9ca5-00b1-4656-9e4c-ddecae8dde02] [servername/WuAyNIIU-2] 2016-10-07 21:49:06 +0000 "GET /two HTTP/1.1" from 127.0.0.1 - 200 64B in 0.000207006931304932s
```

## 使用方法

请首先为 `Package.swift` 文件追加依存关系：

```swift
.Package(url: "https://github.com/PerfectlySoft/Perfect-RequestLogger.git", majorVersion: 0)
```

然后在需要使用日志的源代码开始部分导入函数库：

``` swift 
import PerfectRequestLogger
```

在您的 `main.swift` 文件中增加日志模块，具体位置是启动服务器 `server` 对象之后：

```swift
// 初始化一个日志对象
let myLogger = RequestLogger()

// 增加过滤器
// 注意高优先级的过滤器被优先执行first
server.setRequestFilters([(myLogger, .high)])
// 最低级的过滤器最后再申报
server.setResponseFilters([(myLogger, .low)])
```

这些请求／响应过滤器能够在处理HTTP开始和结束时控制响应内容的处理


## 设置日志文件路径

默认的日志文件路径是`/var/log/perfectLog.log`。如果您需要改变这个路径存储为止，请设置`RequestLogFile.location` 对象属性。

``` swift
RequestLogFile.location = "/var/log/myLog.log"
```


## 问题报告、内容贡献和客户支持

我们目前正在过渡到使用JIRA来处理所有源代码资源合并申请、修复漏洞以及其它有关问题。因此，GitHub 的“issues”问题报告功能已经被禁用了。

如果您发现了问题，或者希望为改进本文提供意见和建议，[请在这里指出](http://jira.perfect.org:8080/servicedesk/customer/portal/1).

在您开始之前，请参阅[目前待解决的问题清单](http://jira.perfect.org:8080/projects/ISS/issues).

=====


## 更多信息
详细信息请参考 Perfect 项目，详见官网[perfect.org](http://perfect.org).