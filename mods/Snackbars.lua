import{ "android.view.*",
  "android.view.animation.*",
  "android.view.animation.Animation$AnimationListener",
  "android.view.animation.AccelerateDecelerateInterpolator",
  "android.view.inputmethod.InputMethodManager",
  "android.animation.Animator",
  "android.animation.ValueAnimator",
  "android.content.res.ColorStateList",
}

SnackerBar={shouldDismiss=true}

local ripple = activity.obtainStyledAttributes({android.R.attr.selectableItemBackgroundBorderless}).getResourceId(0,0)
local ripples = activity.obtainStyledAttributes({android.R.attr.selectableItemBackground}).getResourceId(0,0)

local w=activity.width
local layout={
  LinearLayout,
  Gravity="bottom",
  paddingTop=activity.getResources().getDimensionPixelSize(luajava.bindClass("com.android.internal.R$dimen")().status_bar_height);
  {
    MaterialCardView,
    layout_height=-2,
    layout_width=-1,
    CardElevation="2dp",
    CardBackgroundColor="#FF202124",
    radius="8dp",
    layout_margin="12dp";
    {
      LinearLayoutCompat,
      layout_height=-2,
      layout_width=-2,
      gravity="left|center",
      layout_gravity="left|center",
      padding="16dp";
      --paddingTop="12dp";
      --paddingBottom="12dp";
      {
        MaterialTextView,
        textColor=0xffffffff,
        textSize="14sp";
        layout_height=-2,
        layout_width=-2,
        text="fill";

      },
    },
    {
      MaterialCardView,
      layout_height=-1,
      layout_width=-2,
      CardElevation="0",
      CardBackgroundColor="#FF202124",
      radius="4dp",
      layout_gravity="right|center",
      layout_margin="6dp";

      {
        LinearLayoutCompat,
        layout_height=-1,
        layout_width=-2,
        backgroundDrawable=(activity.Resources.getDrawable(ripple).setColor(ColorStateList(int[0].class{int{}},int{0xffffffff}))),
        padding="8dp";
        paddingLeft="14dp",
        paddingRight="14dp",
        onClick=function()end,
        --paddingTop="12dp";
        --paddingBottom="12dp";
        {
          MaterialTextView,
          textColor=0xffffffff,
          textSize="14sp";
          layout_height=-2,
          layout_width=-2,
          text="";

        },
      }

    }
  }
}

local function addView(view)
  local mLayoutParams=ViewGroup.LayoutParams(-1,-1)
  activity.decorView.addView(view,mLayoutParams)
end

local function removeView(view)
  activity.decorView.removeView(view)
end

function indefiniteDismiss(snackerBar)
  task(3000,function()
    if snackerBar.shouldDismiss==true then
      snackerBar:dismiss()
     else
      indefiniteDismiss(snackerBar)
    end
  end)
end

function SnackerBar:message(text)
  self.textView.text=text
  return self
end

function SnackerBar:button(a,b)
  self.buttonView.text=a
  if b then
    self.buttonView.parent.onClick=function()
      b()
      self:dismiss()
    end
  end
  return self
end

function SnackerBar:dismiss()
  local view=self.view
  view.animate().translationY(300)
  .setDuration(400)
  .setInterpolator(DecelerateInterpolator())
  .setListener(Animator.AnimatorListener{
    onAnimationEnd=function()
      removeView(view)
    end
  }).start()
end

SnackerBar.__index=SnackerBar

function SnackerBar.build()
  local mSnackerBar={}
  setmetatable(mSnackerBar,SnackerBar)
  mSnackerBar.view=loadlayout(layout)
  mSnackerBar.bckView=mSnackerBar.view
  .getChildAt(0)
  mSnackerBar.textView=mSnackerBar.bckView
  .getChildAt(0).getChildAt(0)
  mSnackerBar.buttonView=mSnackerBar.view
  .getChildAt(0).getChildAt(1).getChildAt(0).getChildAt(0)
  local function animate(v,tx,dura)
    ValueAnimator().ofFloat({v.translationX,tx}).setDuration(dura)
    .addUpdateListener( ValueAnimator.AnimatorUpdateListener
    {
      onAnimationUpdate=function( p1)
        local f=p1.animatedValue
        v.translationX=f
        v.alpha=1-math.abs(v.translationX)/w
      end
      }).addListener(ValueAnimator.AnimatorListener{
      onAnimationEnd=function()
        if math.abs(tx)>=w then
          removeView(mSnackerBar.view)
        end
      end
    }).setInterpolator(DecelerateInterpolator()).start()

  end
  local frx,p,v,fx=0,0,0,0
  mSnackerBar.bckView.setOnTouchListener(View.OnTouchListener{
    onTouch=function(view,event)
      if event.Action==event.ACTION_DOWN then
        mSnackerBar.shouldDismiss=false
        frx=event.x-dp2px(8)
        fx=event.x-dp2px(8)
       elseif event.Action==event.ACTION_MOVE then
        if math.abs(event.rawX-dp2px(8)-frx)>=2 then
          v=math.abs((frx-event.rawX-dp2px(8))/(os.clock()-p)/1000)
        end
        p=os.clock()
        frx=event.rawX-dp2px(8)
        view.translationX=frx-fx
        view.alpha=1-math.abs(view.translationX)/w
       elseif event.Action==event.ACTION_UP then
        mSnackerBar.shouldDismiss=true
        local tx=view.translationX
        if tx>=w/5 then
          animate(view,w,(w-tx)/v)
         elseif tx>0 and tx<w/5 then
          animate(view,0,tx/v)
         elseif tx<=-w/5 then
          animate(view,-w,(w+tx)/v)
         else
          animate(view,0,-tx/v)
        end
        fx=0
      end
      return true
    end
  })
  return mSnackerBar
end

function SnackerBar:show()

  local view=self.view
  addView(view)
  if tostring(self.buttonView.Text)=="" then
    self.buttonView.parent.parent.visibility=8
  end
  view.translationY=300
  view.animate().translationY(0)
  .setInterpolator(DecelerateInterpolator())
  .setDuration(400).start()
  indefiniteDismiss(self)



  if _G["_snackbar"] then
    _G["_snackbar"]:dismiss()
  end

  _G["_snackbar"]=self

end


return SnackerBar
