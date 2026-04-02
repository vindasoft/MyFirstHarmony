import { GlobalMusic } from "../models/GlobalMusic"
import { SongItemType } from "../models/music"
import { AppStorageV2 } from "@kit.ArkUI"
import { playerManager } from "../utils/AvPlayerManager"
import { LevelOrder } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// 跳转页面入口函数
@Builder
export function PlayBuilder() {
  Play()
}

@ComponentV2
struct Play {
  @Local panelHeight: string = '0%'
  @Local panelOpacity: number = 0
  pathStack: NavPathStack = new NavPathStack();
  // songs: SongItemType[] = []
  //当前播放的歌曲：！非空断言（不会是空的）
  @Local
  playState: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  // playState: SongItemType = this.songs[0]

  @Builder
  deleteButton(index: number) {
    Button('删除')
      .backgroundColor('#ec5c87')
      .fontColor('#fff')
      .width(80)
      .height('100%')
      .type(ButtonType.Normal)
      .onClick(() => {
        // 按接收到的索引删除歌曲
        playerManager.removeSong(index)
        // 回退到前一页
        this.pathStack.pop()
      })
  }

  @Builder topCustomDialog() {

  }

  number2time(number: number) {
    if (number > 60 * 1000) {
      const s = Math.floor(number / 1000 % 60)
      const m = Math.floor(number / 1000 / 60)
      const second = s.toString().padStart(2, '0')
      const minute = m.toString().padStart(2, '0')
      return minute + ':' + second
    } else {
      const s = Math.floor(number / 1000 % 60)
      const second = s.toString().padStart(2, '0')
      return '00:' + second
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Bottom }) {
        // 播放
        Stack() {
          // 变色背景
          Image(this.playState.img)
            .width('100%')
            .height('100%')
            .blur(1000)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          // 内容
          Column() {
            // 播放界面
            Column() {
              Stack({ alignContent: Alignment.Top }) {
                Row() {
                  Row() {
                    Image(this.playState.img)
                      .width('70%')
                      .borderRadius(400) //187
                  }
                  .backgroundImage($r('app.media.ic_cd'))
                  .backgroundImageSize(ImageSize.Cover)
                  .justifyContent(FlexAlign.Center)
                  .width('100%')
                  .borderRadius(400)
                  .clip(true)
                  .aspectRatio(1)
                }
                .margin({ top: 50 })
                .width('90%')
                .aspectRatio(1)
                .justifyContent(FlexAlign.Center)
                .padding(24)

                // 唱针
                Image($r('app.media.ic_stylus'))
                  .width(150)
                  .aspectRatio(0.5)
                  .rotate({
                    angle: -75,
                    centerX: 30,
                    centerY: 30
                  })
                  .animation({ duration: 500 })
              }

              //歌曲信息
              Stack() {
                // 第一个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#4bb0c4')
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor('#4bb0c4')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(1)

                // 第二个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#ec5c87')
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor('#ec5c87')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(2)

                // 第三个
                Column({ space: 8 }) {
                  Text(this.playState.name)
                    .fontSize(28)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                  Text(this.playState.author)
                    .fontSize(18)
                    .fontColor(Color.White)
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .zIndex(3)
              }
              .layoutWeight(1)

              // 操作
              Row() {
                Badge({ value: '99+', style: { badgeSize: 12, badgeColor: '#45cccccc' } }) {
                  Image($r("app.media.ic_like"))
                  // .fillColor(Color.White)
                    .width(24)
                }

                Badge({ value: '100W', style: { badgeSize: 12, badgeColor: '#45cccccc' } }) {
                  Image($r("app.media.ic_comment_o"))
                  //.fillColor(Color.White)
                    .width(18)
                }

                Badge({ value: 'hot', style: { badgeSize: 12, badgeColor: '#a8ff3131' } }) {
                  Image($r("app.media.ic_bells_o"))
                  // .fillColor(Color.White)
                    .width(24)
                }

                Badge({ value: 'hot', style: { badgeSize: 12, badgeColor: '#b7efd371' } }) {
                  Image($r("app.media.ic_download_o"))
                  //.fillColor(Color.White)
                    .width(24)
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceAround)

              // 播放
              Column() {
                //进度条
                Row({ space: 4 }) {
                  Text(this.number2time(this.playState.time))
                    .fontSize(12)
                    .fontColor(Color.White)
                  Slider({
                    value: this.playState.time,
                    min: 0,
                    max: this.playState.duration
                  })
                    .layoutWeight(1)
                    .blockColor(Color.White)
                    .selectedColor(Color.White)
                    .trackColor('#ccc5c5c5')
                    .trackThickness(2)
                    .onChange((value) => {
                      playerManager.seekPlay(value)
                    })
                  Text(this.number2time(this.playState.duration))
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .width('100%')
                .padding(24)

                // 切换
                Row() {
                  if (this.playState.playMode === 'auto') {
                    // 自动播放
                    Image($r('app.media.ic_auto'))
                    //.fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = 'random'
                      })
                  } else if (this.playState.playMode === 'random') {
                    // 自动播放
                    Image($r('app.media.ic_random'))
                    //.fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = 'repeat'
                      })
                  } else if (this.playState.playMode === 'repeat') {
                    // 自动播放
                    Image($r('app.media.ic_repeat'))
                    // .fillColor(Color.White)
                      .width(30)
                      .onClick(() => {
                        this.playState.playMode = 'auto'
                      })
                  }

                  // 上一首
                  Image($r('app.media.ic_prev'))
                  //.fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      playerManager.prevPlay()
                    })
                  // 播放按钮
                  Image(this.playState.isPlay ? $r('app.media.ic_paused') : $r('app.media.ic_play'))
                  //.fillColor(Color.White)
                    .width(50)
                    .onClick(() => {
                      this.playState.isPlay ? playerManager.paused() :
                      playerManager.singPlay(this.playState.playList[this.playState.playIndex])
                    })

                  // 下一首
                  Image($r('app.media.ic_next'))
                    .fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      playerManager.nextPlay()
                    })

                  // 播放列表
                  Image($r('app.media.ic_song_list'))
                  //.fillColor(Color.White)
                    .width(30)
                    .onClick(() => {
                      this.panelHeight = '50%'
                      this.panelOpacity = 1
                      this.getUIContext().getPromptAction().openCustomDialog({
                        builder: () => {
                          this.topCustomDialog()
                        },
                        levelOrder: LevelOrder.clamp(100000)
                      }).catch((err: BusinessError) => {
                        console.error("openCustomDialog error: " + err.code + " " + err.message)
                      })
                    })
                }
                .width('100%')
                .padding({ bottom: 24 })
                .justifyContent(FlexAlign.SpaceAround)
              }
              .width('100%')
            }
            .layoutWeight(1)
            .width('100%')
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Transparent)

        // 播放列表
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Transparent)
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true) //隐藏标题栏
  }
}