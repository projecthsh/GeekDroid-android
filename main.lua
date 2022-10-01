require "import"
import {
  "android.app.*",
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.content.pm.PackageManager",
  "android.graphics.BitmapFactory",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.animation.LayoutTransition",
  "android.util.TypedValue",
  "java.io.FileInputStream",

  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.viewpager.widget.ViewPager",
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout",
  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",

  "com.google.android.material.appbar.AppBarLayout",
  "com.google.android.material.appbar.MaterialToolbar",
  "com.google.android.material.appbar.CollapsingToolbarLayout",
  "com.google.android.material.card.MaterialCardView",
  "com.google.android.material.bottomnavigation.BottomNavigationView",
  "com.google.android.material.dialog.MaterialAlertDialogBuilder",
  --"com.google.android.material.switchmaterial.SwitchMaterial",
  "com.google.android.material.materialswitch.MaterialSwitch",--谷歌起名一直可以的。MD2主题请继续使用旧库
  "com.google.android.material.textview.MaterialTextView",
  "com.google.android.material.button.MaterialButton",
  "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton",
  "com.google.android.material.tabs.TabLayout",
  "com.google.android.material.button.MaterialButtonToggleGroup",
  "com.google.android.material.textfield.TextInputEditText",
  "com.google.android.material.textfield.TextInputLayout",
  "com.open.lua.widget.ElasticListView",

  "github.daisukiKaffuChino.utils.LuaThemeUtil",
  "com.daimajia.androidanimations.library.Techniques",
  "com.daimajia.androidanimations.library.YoYo",
}

--设置主题
activity.setTheme(R.style.Theme_ReOpenLua_Material3)
import"com.google.android.material.color.DynamicColors"
DynamicColors.applyIfAvailable(this)
--[[reOpenLua+ Open Source Project
     -----Material 3 简单示例 更新1-----
酷安@得想办法娶了智乃 2022.08.18 保留所有权利
运行必要的编辑器版本 reOpenLua+ 0.7.7及以上]]

--更新日志:适配了相关Java方法调整和部分功能重新实现

--小Tip：事实上，reOpenLua+要适配Material You也是很容易的
--但考虑到动态取色仅支持Android 12及以上，缺乏泛用性，故未作支持

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
      layout_scrollFlags="scroll|exitUtilCollapsed|snap",
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
        --在类似使用场景中我们更推荐FragmentContainerView。不过这不在本demo演示范围内
        layout_width="fill",
        layout_height="fill",
        pages={
          "page_file",
          "page_download",
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
bottombar.menu.add(0,0,0,"本地")
bottombar.menu.add(0,1,1,"下载")
bottombar.menu.add(0,2,2,"主页")
bottombar.menu.add(0,3,3,"我的")--参数分别对应groupid homeid order name
bottombar.menu.add(0,4,4,"设置")
--设置底栏图标
bottombar.menu.findItem(0).setIcon(getFileDrawable("content-save"))
bottombar.menu.findItem(1).setIcon(getFileDrawable("download"))--这里findItem取的是home id
bottombar.menu.findItem(2).setIcon(getFileDrawable("home"))
bottombar.menu.findItem(3).setIcon(getFileDrawable("tooltip-account"))
bottombar.menu.findItem(4).setIcon(getFileDrawable("cog"))
--MaterialToolbar比普通Toolbar更强大的地方在于，它可以脱离Activity使用
local addToolbarMenu=lambda a,b,c,name:toolbar.menu.add(a,b,c,name)
addToolbarMenu(0,0,0,"About")
addToolbarMenu(0,1,1,"Exit")
--这里展示了标准lua没有的AndroLua+专属语法lambda(匿名函数)
--可以大幅简化重复函数调用。上面的底栏也是可以用lambda添加的。

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

--[[初始化TabLayout(弃用)
local tabTable={"Pie Chart","Bar Chart"}
for i=1, #tabTable do
  mtab.addTab(mtab.newTab().setText(tabTable[i]))
end
cvpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    mtab.getTabAt(v).select()
end})

mtab.addOnTabSelectedListener(TabLayout.OnTabSelectedListener{
  onTabSelected = function(tab)
    cvpg.setCurrentItem(tab.getPosition())
end})]]

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

--已知bug：
--底栏的behavior不知道为什么写着写着就失效了..懒得研究了

--[[------------------------------

Material Design是自由的，在符合视觉协调的基础上，你也可以发挥想象力打造自己的UI
本演示DEMO在有限的篇幅里，并不能做到面面俱到，对于真正的程序设计知识依旧是沧海一粟。
多多实践，不要再被评论区的老年布局骗了，希望大家能用reOpenLua+写出优美的程序!
酷安@得想办法娶了智乃 保留所有权利 未经本人允许禁止转载

--------------------------------]]


--shizukuSwitch.setClickable(false)

themeSwitch.onClick=function()
  bottombar.setSelectedItemId(4)
  activity.switchDayNight()
end

onNightModeChanged=function()
  bottombar.setSelectedItemId(4)
end



--适配器data数据表
data={
  {标题="列表标题",内容="列表内容"},
};

--适配器item项目布局
item={
  LinearLayoutCompat;--线性控件
  orientation='vertical';--布局方向
  layout_width='fill';--布局宽度
  layout_height='wrap';--布局高度
  padding='10dp';--控件内边距
  {
    MaterialTextView;--文本控件
    layout_width='fill';--控件宽度
    layout_height='wrap';--控件高度
    textSize='16sp';--文字大小
    textColor='#333333';--文字颜色
    id='标题';--设置控件ID
    gravity='center';--重力
  };
  {
    MaterialTextView;--文本控件
    layout_width='fill';--控件宽度
    layout_height='wrap';--控件高度
    textSize='16sp';--文字大小
    --textColor='#333333';--文字颜色
    id='内容';--设置控件ID
    gravity='center';--重力
  };
};


--构建适配器
adapter=LuaAdapter(activity,data,item)
list.setAdapter(adapter)

list.onItemClick=function(l,v,p,i)--列表适配器点击事件
  print("点击  "..v.Tag.标题.text)
end

list.onItemLongClick=function(l,v,p,i)--列表适配器长按事件
  print("长按  "..v.Tag.标题.text)
  return true
end



--动态添加内容
for i = 0,2
  adapter.add{标题="列表标题4",内容="列表内容4"}--将一组内容添加到适配器
  adapter.add{标题="列表标题5",内容="列表内容5"}--将一组内容添加到适配器
  adapter.add{标题="列表标题6",内容="列表内容6"}--将一组内容添加到适配器
end

--插入内容,从0开始记数
adapter.insert(3,{标题="列表标题7",内容="动态插入-列表内容7"})

list.setOnScrollListener{
  onScrollStateChanged=function(l,s)
    --适配器滑动时
    if list.getLastVisiblePosition()==list.getCount()-1 then
      --列表已经下滑到最底部
    end
  end
}

--[[
--删除内容,从0开始记数
--adapter.remove(0)
--清空所有内容
--adapter.clear()--清空适配器
--更新数据,如果data表有变动，用这个更新显示
adapter.notifyDataSetChanged()
adapter.getCount()--获取当前item个数
adapter.getData()--获取适配器的data表
list.setSelection(0)--跳转到第几个item位置
]]