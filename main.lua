require "import"
import {
  "android.app.*",
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.content.pm.PackageManager",
  "android.content.Intent",
  "android.graphics.BitmapFactory",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.animation.LayoutTransition",
  "android.util.TypedValue",
  "java.io.FileInputStream",

  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.viewpager.widget.ViewPager",
  "androidx.recyclerview.widget.RecyclerView",
  "androidx.recyclerview.widget.LinearLayoutManager",
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout",
  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",

  "com.google.android.material.appbar.AppBarLayout",
  "com.google.android.material.appbar.MaterialToolbar",
  "com.google.android.material.appbar.CollapsingToolbarLayout",
  "com.google.android.material.card.MaterialCardView",
  "com.google.android.material.bottomnavigation.BottomNavigationView",
  "com.google.android.material.dialog.MaterialAlertDialogBuilder",
  "com.google.android.material.materialswitch.MaterialSwitch",
  "com.google.android.material.textview.MaterialTextView",
  "com.google.android.material.button.MaterialButton",
  "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton",
  "com.google.android.material.tabs.TabLayout",
  "com.google.android.material.button.MaterialButtonToggleGroup",
  "com.google.android.material.textfield.TextInputEditText",
  "com.google.android.material.textfield.TextInputLayout",

  "github.daisukiKaffuChino.LuaCustRecyclerAdapter",
  "github.daisukiKaffuChino.AdapterCreator",
  "github.daisukiKaffuChino.LuaCustRecyclerHolder",
  "github.daisukiKaffuChino.utils.LuaThemeUtil",
  "com.daimajia.androidanimations.library.Techniques",
  "com.daimajia.androidanimations.library.YoYo",
  "me.everything.android.ui.overscroll.*",
  "mods.fun",
}

--设置主题
activity.setTheme(R.style.Theme_ReOpenLua_Material3)
import"com.google.android.material.color.DynamicColors"
DynamicColors.applyIfAvailable(this)

--初始化颜色
--为了使深色主题效果正常，请不要使用硬编码颜色!
local themeUtil=LuaThemeUtil(this)
MDC_R=luajava.bindClass"com.google.android.material.R"
surfaceColor=themeUtil.getColorSurface()
--更多颜色分类 请查阅Material.io官方文档
backgroundc=themeUtil.getColorBackground()
surfaceVar=themeUtil.getColorSurfaceVariant()
titleColor=themeUtil.getTitleTextColor()
primaryc=themeUtil.getColorPrimary()
primarycVar=themeUtil.getColorPrimaryVariant()

--初始化ripple
rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

function getFileDrawable(file)
  fis = FileInputStream(activity.getLuaDir().."/res/"..file..".png")
  bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end



layout={
  CoordinatorLayout,
  layout_width="fill",
  layout_height="fill",
  {
    AppBarLayout,
    layout_width="fill",
    layout_height="100dp",
    {
      CollapsingToolbarLayout,
      layout_width="fill",
      layout_height="fill",
      layout_scrollFlags="exitUtilCollapsed|snap",
      title="GeekDroid",
      background=ColorDrawable(surfaceVar),
      --expandedTitleColor="#FFFFFF",
      --collapsedTitleTextColor="#FFFFFF",
      --展开 和 收起 时的标题颜色
      {
        MaterialToolbar,
        id="toolbar",
        layout_collapseMode="pin",
        background=ColorDrawable(surfaceVar),
        layout_width="fill",
        layout_height="56dp",
      },
    },
  },
  {
    NestedScrollView,
    layout_width="fill",
    layout_height="fill",
    layout_behavior="@string/appbar_scrolling_view_behavior",
    fillViewport="true",
    backgroundColor=backgroundc,
    {
      LinearLayoutCompat,
      id="content",
      layout_width="fill",
      layout_height="fill",
      orientation="vertical",
      --[
      {
        ViewPager,
        id="vpg",
        --无缝迁移到新标准库，reOpenLua+已经过优化，像使用PageView一样使用ViewPager！
        --在类似使用场景中我们更推荐Fragfunction()mentContainerView。不过这不在本demo演示范围内
        layout_width="fill",
        layout_height="fill",
        pages={
          "page_file",
          "page_find",
          "page_home",
          "page_user",
          "page_setting",
        },
      },
    },
  },
  {
    BottomNavigationView,
    id="bottombar",
    layout_gravity="bottom",
    layout_width="fill",
    layout_height="wrap",
  },
  {
    ExtendedFloatingActionButton,
    id="fab",
    text="More",
    onClick="onClickFab",
    icon=getFileDrawable("outline_info_black_24dp"),
    layout_gravity="bottom|end",
    layout_marginBottom="110dp",
    layout_marginEnd="16dp",
  },
}

--设置布局
activity.setContentView(loadlayout(layout))
--隐藏自带ActionBar
activity.getSupportActionBar().hide()
--配置状态栏颜色
local window = activity.getWindow()
window.setStatusBarColor(surfaceVar)
window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
window.setNavigationBarColor(surfaceVar)

--设置Material底栏。谷歌将启用新的BottomAppBar,两者区别不大，故不再作展示
--得益于CoordinatorLayout的强大支持，配合layout_behavior轻松实现滚动隐藏
local bottombarBehavior=luajava.bindClass"com.google.android.material.behavior.HideBottomViewOnScrollBehavior"
bottombar.layoutParams.setBehavior(bottombarBehavior())
bottombar.setLabelVisibilityMode(0)--设置tab样式

--设置底栏项目
bottombar.menu.add(0,0,0,"文件")
bottombar.menu.add(0,1,1,"发现")
bottombar.menu.add(0,2,2,"主页")
bottombar.menu.add(0,3,3,"我的")--参数分别对应groupid homeid order name
bottombar.menu.add(0,4,4,"设置")
--设置底栏图标
bottombar.menu.findItem(0).setIcon(getFileDrawable("content-save"))
bottombar.menu.findItem(1).setIcon(getFileDrawable("find-replace"))--这里findItem取的是home id
bottombar.menu.findItem(2).setIcon(getFileDrawable("home"))
bottombar.menu.findItem(3).setIcon(getFileDrawable("tooltip-account"))
bottombar.menu.findItem(4).setIcon(getFileDrawable("cog"))
--MaterialToolbar比普通Toolbar更强大的地方在于，它可以脱离Activity使用
local addToolbarMenu=lambda a,b,c,name:toolbar.menu.add(a,b,c,name)
addToolbarMenu(0,0,0,"About")
addToolbarMenu(0,1,1,"Exit")

--顶栏菜单点击监听
import "androidx.appcompat.widget.Toolbar$OnMenuItemClickListener"
toolbar.setOnMenuItemClickListener(OnMenuItemClickListener{
  onMenuItemClick=function(item)
  switch item.getItemId() do
     case 0
      --Material 风格的对话框
      MaterialAlertDialogBuilder(this)
      .setTitle("About this Application")
      .setMessage("GeekDroid\nCopyright ©2022 OtakusNetwork\nAll rights reserved.")
      .setPositiveButton("取消",function()
      end)
      .setNegativeButton("知道了",nil)
      .show()
     case 1
      activity.finish()
    end
  end
})

fab.setVisibility(8)
--ViewPager和BottomNavigationView联动
vpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    bottombar.getMenu().getItem(v).setChecked(true)
    if v~=1 then
      YoYo.with(Techniques.ZoomOut).duration(200).playOn(fab)
      task(200,function()fab.setVisibility(8)end)
     else
      fab.setVisibility(0)
      YoYo.with(Techniques.ZoomIn).duration(200).playOn(fab)
    end
end})



bottombar.setOnNavigationItemSelectedListener(BottomNavigationView.OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)
    vpg.setCurrentItem(item.getItemId())
    return true
end})
--默认主页
bottombar.setSelectedItemId(2)

--MD3 Demo 1.1
--一行解决控件联动。使用LuaPagerAdapter新增的构造方法，支持在布局表中设置标题!
mtab.setupWithViewPager(cvpg)

--悬浮按钮点击事件
function onClickFab()
  MaterialAlertDialogBuilder(this)
  .setTitle("More")
  .setIcon(getFileDrawable("outline_info_black_24dp"))
  .setMessage("")
  .setPositiveButton("知道了",nil)
  .show()
  -- print(bottombar.getSelectedItemId())
end


--尝试增大TextInputLayout圆角，虽然不增大也挺好看的
local function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
local corii={dp2px(24),dp2px(24),dp2px(24),dp2px(24)}
t1.setBoxCornerRadii(table.unpack(corii))
t2.setBoxCornerRadii(table.unpack(corii))




--尝试解决切换模式的问题
themeSwitch.onClick=function()
  bottombar.setSelectedItemId(4)
  activity.switchDayNight()
end

onNightModeChanged=function()
  bottombar.setSelectedItemId(4)
end





function getOriginalSuperTable()
  local json_table=[[
[{
  "ids": "air.com.adobe.pstouchphone",
  "name": "PS Touch",
  "logo": "https://source-projecthsh.bangumi.cyou/%E5%9B%BE%E6%A0%87/PS%20CC_9.9.9.png",
  "screenshorts": [
  ],
  "desc": "Android版PhotoShop",
  "tags": [
    "图像处理"
  ]
},
{
  "ids": "eu.kanade.tachiyomi",
  "name": "Tachiyomi",
  "logo": "https://source-projecthsh.bangumi.cyou/%E5%9B%BE%E6%A0%87/PS%20CC_9.9.9.png",
  "screenshorts": [
    "https://source-projecthsh.bangumi.cyou/%E6%88%AA%E5%9B%BE/home_library-light.png",
    "https://source-projecthsh.bangumi.cyou/%E6%88%AA%E5%9B%BE/home_tracking-light.png",
    "https://source-projecthsh.bangumi.cyou/%E6%88%AA%E5%9B%BE/home_reader-light.png"
  ],
  "desc": "免费开源漫画订阅阅读软件",
  "tags": [
    "阅读器",
    "漫画",
    "开源"
  ]
}
]
]]

  cjson=require "cjson"
  local superTable=cjson.decode(json_table)
  return superTable
end
superTable=getOriginalSuperTable()





Mitem={
  LinearLayoutCompat;
  orientation='vertical';
  layout_width='fill';
  layout_height='wrap';
  id="content",
  padding='10dp';
  {
    MaterialTextView;
    layout_width='fill';
    layout_height='wrap';
    textSize='16sp';
    textColor='#333333';
    id='title';
    gravity='center';
  };
  {
    MaterialTextView;
    layout_width='fill';
    layout_height='wrap';
    textSize='16sp';
    id='profile';
    gravity='center';
  };
};




adapterm=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #superTable
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local views={}
    holder=LuaCustRecyclerHolder(loadlayout(Mitem,views))
    holder.view.setTag(views)
    return holder
  end,
  onBindViewHolder=function(holder,position)
    view=holder.view.getTag()
    view.title.Text=superTable[position+1].name
    view.profile.Text=superTable[position+1].ids
    view.content.backgroundResource=rippleRes.resourceId
    view.content.onClick=function()
      print(superTable[position+1].name)
    end
    view.content.onLongClick=function()
      --print(superTable[position+1].ids)
    end
  end,
}))

recycler_view.setAdapter(adapterm)
recycler_view.setLayoutManager(LinearLayoutManager(this))
OverScrollDecoratorHelper.setUpOverScroll(recycler_view, OverScrollDecoratorHelper.ORIENTATION_VERTICAL)
