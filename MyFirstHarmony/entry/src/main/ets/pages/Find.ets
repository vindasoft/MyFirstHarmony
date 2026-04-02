import { AppStorageV2 } from '@kit.ArkUI'
import { SongItemType } from '../models/music'
import { playerManager } from '../utils/AvPlayerManager'
import { GlobalMusic } from '../models/GlobalMusic'

@ComponentV2
  // 开放给别的组件调用
export struct Find {
  songs: SongItemType[] = [
    {
      img: 'http://imge.kugou.com/stdmusic/120/20240809/20240809163005359578.jpg',
      name: '直到世界的尽头',
      author: 'WANDS',
      url: 'https://ting8.yymp3.com/new27/liyugang6/4.mp3',
      id: '0000'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/1.jpg',
      name: '画',
      author: '赵磊',
      url: 'https://ting8.yymp3.com/new27/liyugang6/6.mp3',
      id: '0001'
    },
    {
      img: 'http://imge.kugou.com/stdmusic/120/20250415/20250415161430875872.jpg',
      name: 'Sweet Dreams',
      author: 'TPaul Sax / Eurythmics',
      url: 'https://ting8.yymp3.com/new27/liyugang6/5.mp3',
      id: '0002'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/3.jpg',
      name: '肖战MV',
      author: '肖战',
      url: 'https://ting8.yymp3.com/new27/vae13/1.mp3',
      id: '0003'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.jpg',
      name: 'only you',
      author: 'DaHuaXiYou',
      url: 'https://ting8.yymp3.com/new27/liyugang6/3.mp3',
      id: '0004'
    },
    {
    img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/5.jpg',
    name: '写一首歌',
    author: '郑一肖',
    url: 'https://ting8.yymp3.com/new27/zhenyixiao/1.mp3',
    id: '0005'
  },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/6.jpg',
      name: '下一站',
      author: '郑一肖',
      url: 'https://ting8.yymp3.com/new27/liyugang6/2.mp3',
      id: '0006'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/7.jpg',
      name: '永远的你',
      author: '郑一肖',
      url: 'https://ting8.yymp3.com/new27/luotianyi4/1.mp3',
      id: '0007'
    }

  ]
  // AppStorageV2控制跳转的对象: !非空断言
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  //当前播放的歌曲
  @Local
  playState: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  build() {
    Column() {
      Text('猜你喜欢')
        .fontColor('#fff')
        .width('100%')
        .margin({ bottom: 10 })
      List() {
        ForEach(this.songs, (item: SongItemType, index: number) => {
          ListItem() {
            Row() {
              // 图
              Stack() {
                Image(item.img)
                  .width(80)
                  .border({ radius: 8 })
                  .margin({ right: 10 })
                if(this.playState.url === item.url && this.playState.isPlay) {
                Image($r('app.media.wav'))
                  .width(24)
                }
              }

              // 字
              Column() {
                Text(item.name)
                  .fontColor('#f3f3f3')
                  .width('100%')
                  .fontWeight(700)
                  .margin({ bottom: 15 })
                Row() {
                  Text('VIP')
                    .fontColor('#9A8E28')
                    .border({ width: 1, color: '9A8E28', radius: 12 })
                    .padding({ left: 5, right: 5, top: 3, bottom: 3 })
                    .margin({right:10})
                  Text(item.author)
                    .fontColor('#696969')
                }
                .width('100%')
              }
              .layoutWeight(1)

              // 更多
              Image($r('app.media.ic_more1'))
                .width(24)
                .fillColor('#FEFEFE')
            }
            .width('100%')
            .height(80)
            .margin({ bottom: 10 })
            .onClick(() => {
              this.pathStack.pushPathByName('Play', null, false)
              playerManager.singPlay(item)
            })
          }
        })
      }
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#131313')
    .padding({ left: 10, right: 10 })
    // 扩充组件安全区
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}