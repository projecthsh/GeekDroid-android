function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end

function snack(content)
  local _v=Snackbar.make(vpg,content,Snackbar.LENGTH_SHORT).show();
  if vpg.getCurrentItem() == 1 then
    _v.setAnchorView(fab)
   else
    _v.setAnchorView(bottombar)
  end
end

--初始化ripple
rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

function getFileDrawable(file)
  fis = FileInputStream(activity.getLuaDir().."/res/"..file..".png")
  bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end

--隐藏输入法
function hideInput(inputid)
  import "android.view.inputmethod.InputMethodManager"
  activity.getSystemService(Context.INPUT_METHOD_SERVICE).hideSoftInputFromWindow(inputid.getWindowToken(),0)
end

