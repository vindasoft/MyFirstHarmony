interface dailyRecommendType {
  img: string //图片
  title: string //介绍文字
  type: string //标题文字
  top: string //标题背景色
  bottom: string //简介背景色
}

interface recommendListType {
  img: string //图片
  count: string //个数
  title: string //介绍文字
  type: string //标题文字
  top: string //标题背景色
  bottom: string //简介背景色
}

@Component
// 开放给别的组件调用
export struct Recommend {
  swiperList: Array<string> = [
    "https://img2.baidu.com/it/u=433875902,3200056221&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
    "https://img1.baidu.com/it/u=848211016,2836436515&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
    "https://img0.baidu.com/it/u=1663599296,2504994396&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=263",
    "https://i2.hdslb.com/bfs/archive/6126fbe0f470375aa3f91fe60e777e60b91dbc02.jpg",
    "https://img1.baidu.com/it/u=2606365882,1237474441&fm=253&fmt=auto&app=138&f=PNG?w=889&h=500"
  ]

  dailyRecommend: dailyRecommendType[] = [
    {
      img: 'https://img2.baidu.com/it/u=4013084658,2370829559&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500',
      title: '每日推荐 | 今天从《江南》听起 | 私人雷达',
      type: '每日推荐',
      top: '#660000',
      bottom: '#90EE90'
    },
    {
      img: 'https://img2.baidu.com/it/u=2854760753,2642668692&fm=253&fmt=auto&app=138&f=PNG?w=499&h=182',
      title: '私人漫游 | 今天从《李智恩》听起 | 私人雷达',
      type: '私人漫游',
      top: '#660000',
      bottom: '#ADFF2F'
    },
    {
      img: 'https://img2.baidu.com/it/u=2854760753,2642668692&fm=253&fmt=auto&app=138&f=PNG?w=499&h=182',
      title: '华语流行 | 今天从《华语流行》听起 | 私人雷达',
      type: '华语流行',
      top: '#660000',
      bottom: '#4169E1'
    }
  ]

  // 推荐歌单：滚动展示
  recommendList: recommendListType[] = [
    {
      img: 'https://img2.baidu.com/it/u=4013084658,2370829559&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500',
      count: '23',
      title: '推荐歌单 | 今天从《江南》听起 | 私人雷达',
      type: '推荐歌单',
      top: '#660000',
      bottom: '#382e2f'
    },
    {
      img: 'https://img2.baidu.com/it/u=2854760753,2642668692&fm=253&fmt=auto&app=138&f=PNG?w=499&h=182',
      count: '234',
      title: 'Top10排行帮 | 今天从《李智恩》听起 | 私人雷达',
      type: 'Top10排行帮',
      top: '#660000',
      bottom: '#382e2f'
    },
    {
      img: 'https://img2.baidu.com/it/u=2854760753,2642668692&fm=253&fmt=auto&app=138&f=PNG?w=499&h=182',
      count: '123',
      title: '欧美流行 | 今天从《华语流行》听起 | 私人雷达',
      type: '欧美流行',
      top: '#660000',
      bottom: '#382e2f'
    }
  ]

  @Builder titleBuilder(title: string){
     Row() {
       Text(title)
         .fontColor('#fff')
         .fontWeight(700)
         .layoutWeight(1)
       Image($r('app.media.ic_more'))
         .width(22)
         .fillColor('#fff')
     }
     .width('100%')
     .height(40)
  }

  build() {
    Column() {
      // 搜索区域
      Row(){
         Image($r('app.media.ic_search'))
           .width(22)
           .fillColor('#817D83')
         TextInput({placeholder: '只因你太美💖'})
           .placeholderColor('#817D83')
           .padding({left: 5})
           .fontColor('#999')
           .layoutWeight(1)
         Image($r('app.media.ic_code'))
           .width(20)
      }
      .width('100%')
      .backgroundColor('#2D2B29')
      .border({radius: 20})
      .padding({left: 8, right: 8})

      // 轮播图区域
      Swiper(){
        ForEach(this.swiperList,(item: string) =>{
           Image(item)
             .width('100%')
             .height(200)
             .border({radius: 10})
        })
      }.autoPlay(true)

      // 每日推荐区域
      this.titleBuilder('每日推荐')
      List() {
        ForEach(this.dailyRecommend, (item: dailyRecommendType) => {
          ListItem(){
            Column(){
                Text(item.type)
                  .width('100%')
                  .height(40)
                  .backgroundColor(item.top)
                  .padding({left: 5})
                  .fontSize(14)
                  .fontColor('#fff')
              Image(item.img)
                .width('100%')
                .height(120)
              Text(item.title)
                .width('100%')
                .backgroundColor(item.bottom)
                .padding(5)
                .fontSize(14)
                .fontColor('#fff')
                .maxLines(2)
                .textOverflow({overflow: TextOverflow.Ellipsis})
            }
            .width('40%')
           // .height(200)
            //.backgroundColor(Color.Pink)
            .border({radius: 10})
            .margin({right: 10})
            .clip(true)
          }
        })
      }
      .listDirection(Axis.Horizontal) //调整list 布局的方向水平布局
      .height(210)
      .scrollBar(BarState.Off) // 去掉横向滑动条

      // 推荐歌单
      this.titleBuilder('推荐歌单')
      List() {
        ForEach(this.recommendList, (item: recommendListType) => {
          ListItem() {
            Column() {
              Stack({ alignContent: Alignment.TopStart }) {
                Image(item.img)
                  .width('100%')
                  .height(120)
                  .border({ radius: 8 })
                Text(item.count)
                  .fontColor('#fff')
                  .fontSize(12)
                  .fontWeight(700)
                  .margin(5)
              }

              Text(item.title)
                .fontColor('#fff')
                .fontSize(14)
                .width('100%')
                .padding(5)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width('30%')
            .margin({ right: 10 })
          }
        })
      }
      .listDirection(Axis.Horizontal) //调整list 布局的方向
    }
    .width('100%')
    .height('100%')
    .padding({left: 10, right: 10, top: 5, bottom: 5})
  }
}