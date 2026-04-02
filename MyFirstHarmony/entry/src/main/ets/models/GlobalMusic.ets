import { SongItemType } from "./music"

// @ObservedV2类属性观测能力，@Trace装饰类的属性
@ObservedV2
export class GlobalMusic {
  @Trace img: string = '' //音乐封面
  @Trace name: string = '' //音乐名称
  @Trace author: string = '' //音乐作者
  @Trace url: string = '' //当前播放链接地址
  @Trace time: number = 0 //播放时间
  @Trace duration: number = 0 // 音乐的播放总时长

  // 歌曲列表
  @Trace playIndex: number = 0 //当前播放的索引
  @Trace playList: SongItemType[] = [] //播放列表里面的歌曲
  @Trace isPlay: boolean = false
  @Trace playMode: 'auto' | 'random' | 'repeat' = 'auto'

  reset() {
    this.img = ''
    this.name = ''
    this.author = ''
    this.url = ''
    this.time = 0
    this.duration = 0
    this.playIndex = 0
    this.playList = []
    this.isPlay = false
    this.playMode = 'auto'
  }
}