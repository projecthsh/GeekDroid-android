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
      background=ColorDrawable(backgroundc),
      --expandedTitleColor="#FFFFFF",
      --collapsedTitleTextColor="#FFFFFF",
      --展开 和 收起 时的标题颜色
      {
        MaterialToolbar,
        id="toolbar",
        layout_collapseMode="pin",
        background=ColorDrawable(backgroundc),
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
        CustomViewPager,
        id="vpg",
        layout_width="fill",
        layout_height="fill",
        Swipeable=true,
        pages={
          "pages/page_file",
          "pages/page_find",
          "pages/page_home",
          "pages/page_json",
          "pages/page_setting",
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
    text="刷新",
    icon=getFileDrawable("round_refresh_black_24dp"),
    layout_gravity="bottom|end",
    layout_marginBottom="110dp",
    layout_marginEnd="16dp",
    backgroundColor=tertiaryc,
    textColor=ontertiaryc,
    IconTint=ColorStateList.valueOf(ontertiaryc),
    RippleColor=ColorStateList.valueOf(ontertiaryContain),
    onClick="onClickFab",
  },
}

--设置布局
activity.setContentView(loadlayout(layout))
--隐藏自带ActionBar
activity.getSupportActionBar().hide()
--配置状态栏颜色
local window = activity.getWindow()
window.setStatusBarColor(backgroundc)
window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
window.setNavigationBarColor(surfaceVar)

local bottombarBehavior=luajava.bindClass"com.google.android.material.behavior.HideBottomViewOnScrollBehavior"
bottombar.layoutParams.setBehavior(bottombarBehavior())
bottombar.setLabelVisibilityMode(0)--设置tab样式

--设置底栏项目
local bottomMenu={"本地","发现","主页","创建","设置"}
for key,v in ipairs(bottomMenu) do
  local itemK=key-1
  --参数分别对应groupid homeid order name
  bottombar.menu.add(0,itemK,itemK,v)
end
--设置底栏图标
local bottomIcon={"content-save","find-replace","home","application-cog","cog"}
for key,v in ipairs(bottomIcon) do
  local itemK=key-1
  --这里findItem取的是home id
  bottombar.menu.findItem(itemK).setIcon(getFileDrawable(v))
end

--MaterialToolbar比普通Toolbar更强大的地方在于，它可以脱离Activity使用
local addToolbarMenu=lambda a,b,c,name:toolbar.menu.add(a,b,c,name)
addToolbarMenu(0,0,0,"换源")
addToolbarMenu(0,1,1,"退出")


mainProgress
.getIndeterminateDrawable()
.setColorFilter(tertiaryc, PorterDuff.Mode.SRC_IN)


fab.setVisibility(8)
--ViewPager和BottomNavigationView联动
vpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    bottombar.getMenu().getItem(v).setChecked(true)
    if v==1 then
      fab.setVisibility(0)
      YoYo.with(Techniques.ZoomIn).duration(200).playOn(fab)
     else
      YoYo.with(Techniques.ZoomOut).duration(200).playOn(fab)
      task(200,function()fab.setVisibility(8)end)
      if v==0 and _isLoaded~=true then
        --显示本地列表
        _isLoaded=true
        loadLocalList()
        collectgarbage("collect")
        --[[
       elseif v==2 then
        YoYo.with(Techniques.FadeIn).duration(384).playOn(home_content)
       elseif v==3 then
        YoYo.with(Techniques.FadeIn).duration(384).playOn(json_content)
       elseif v==4 then
        YoYo.with(Techniques.FadeIn).duration(384).playOn(setting_content)
        ]]
      end
    end
end})


bottombar.setOnNavigationItemSelectedListener(BottomNavigationView.OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)
    vpg.setCurrentItem(item.getItemId())
    return true
end})
--默认主页
bottombar.setSelectedItemId(2)
--一行解决控件联动。使用LuaPagerAdapter新增的构造方法，支持在布局表中设置标题!
mtab.setupWithViewPager(cvpg)

--给主页面ProgressBar勉强设置一个动画
YoYo.with(Techniques.FadeIn).duration(500).playOn(mainProgress)
YoYo.with(Techniques.FadeIn).duration(500).playOn(optionText)
