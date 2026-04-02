// 广告页面入口函数：跳转页面
@Builder
export function StartBuilder() {
  Start()
}

@Component
struct Start {
  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack()
  aboutToAppear(): void {
    setTimeout(() => {
      this.pathStack.replacePathByName("Layout", null, false)
    },3000)
  }

  build() {
    NavDestination() {
       /*Button('点击跳转到布局页')
         .onClick(() => {
           this.pathStack.pushPathByName("Layout", null, false)
         })*/
      // 层叠布局函数
      Stack({alignContent: Alignment.TopEnd}){
        Image($r('app.media.adv'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        Button('跳过')
          .backgroundColor(Color.Gray)
          .margin(15)
          .onClick(() => {
            //pushPathByName这种是支持跳回的跳转
            //this.pathStack.pushPathByName("Layout", null, false);
            //replacePathByName改成不支持跳回的跳转
            this.pathStack.replacePathByName("Layout", null, false)
          })
      }
    }
    //.title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}