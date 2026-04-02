import { AppStorageV2 } from "@kit.ArkUI"

@Entry
@Component
struct Index {
  // 控制跳转的对象
  //pathStack: NavPathStack = new NavPathStack()
  // 控制跳转的对象: !非空断言
   pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

   build() {
     Navigation(this.pathStack) {
     }.onAppear(() => {
       // pathStack就是跳转的意思
       this.pathStack.pushPathByName("Start", null, false);
     })
     .hideNavBar(true) // 不会把自己放到控制跳转的对象里面->点返回的时候不会返回到这个导航页
   }
}