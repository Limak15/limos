-- IMPORTS
--Default
import XMonad
import qualified XMonad.StackSet as W

--Data
import Data.Maybe (fromJust)
import Data.Monoid
import System.Exit
import qualified Data.Map as M

--Layout
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)

--Utils
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad

--Hooks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.WindowSwallowing

--Actions
import XMonad.Actions.CycleWS

-- Bindings for keyboard multimedia keys
import Graphics.X11.ExtraTypes.XF86

-- Variables
myTerminal :: String -- Default terminal
myTerminal = "kitty"

myFocusFollowsMouse :: Bool -- Whether focus follows the mouse pointer.
myFocusFollowsMouse = True 

myClickJustFocuses :: Bool -- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses = False 

myBorderWidth :: Dimension -- Width of the window border in pixels.
myBorderWidth = 2 

myModMask :: KeyMask --default mod key (mod4Mask == Windows key)
myModMask = mod4Mask

myNormalBorderColor :: String -- Not focused window border color
myNormalBorderColor  = "#282c34"

myFocusedBorderColor :: String -- Focused window border color
myFocusedBorderColor = "#2cc55d" 

--Workspace names
myWorkspaces :: [WorkspaceId]
myWorkspaces = map show [1..9]


-- Key bindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
        ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf),                                    -- Launch a terminal
        ((modm,               xK_p     ), spawn "rofi -show drun"),                                         -- Launch rofi
        ((modm .|. shiftMask, xK_Right ), nextWS),                                                          -- Switch to next workspace 
        ((modm .|. shiftMask, xK_Left  ), prevWS),                                                          -- Switch to next workspace 
        ((modm .|. shiftMask, xK_c     ), kill),                                                            -- Close focused window
        ((modm,               xK_space ), sendMessage NextLayout),                                          -- Rotate through the available layout algorithms
        ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf),                              -- Reset the layouts on the current workspace to default
        ((modm,               xK_n     ), refresh),                                                         -- Resize viewed windows to the correct size
        ((modm,               xK_Tab   ), windows W.focusDown),                                             -- Move focus to the next window
        ((modm,               xK_j     ), windows W.focusDown),                                             -- Move focus to the next window
        ((modm,               xK_k     ), windows W.focusUp  ),                                             -- Move focus to the previous window
        ((modm,               xK_m     ), windows W.focusMaster  ),                                         -- Move focus to the master window
        ((modm,               xK_Return), windows W.swapMaster),                                            -- Swap the focused window and the master window
        ((modm .|. shiftMask, xK_j     ), windows W.swapDown  ),                                            -- Swap the focused window with the next window
        ((modm .|. shiftMask, xK_k     ), windows W.swapUp    ),                                            -- Swap the focused window with the previous window
        ((modm,               xK_f     ), sendMessage (JumpToLayout "Full")),                               -- Set currently focused window to full screen
        ((modm,               xK_Right     ), sendMessage Expand),                                          -- Shrink window horizontaly
        ((modm,               xK_Left     ), sendMessage Shrink),                                           -- Expand window horizontaly
        ((modm,               xK_Up),        sendMessage MirrorExpand),                                     -- Expand window verticaly 
        ((modm,               xK_Down),        sendMessage MirrorShrink),                                   -- Shrink window verticaly
        ((modm,               xK_t     ), withFocused $ windows . W.sink),                                  -- Push window back into tiling
        ((modm              , xK_comma ), sendMessage (IncMasterN 1)),                                      -- Increment the number of windows in the master area
        ((modm              , xK_period), sendMessage (IncMasterN (-1))),                                   -- Deincrement the number of windows in the master area
        ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)),                                       -- Quit xmonad
        ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart"),                    -- Restart xmonad
        ((0                 , xF86XK_AudioRaiseVolume), spawn ("$HOME/.local/bin/limos-changevolume up")),        -- Volume up
        ((0                 , xF86XK_AudioLowerVolume), spawn ("$HOME/.local/bin/limos-changevolume down")),      -- Volume down
        ((0                 , xF86XK_AudioMute), spawn ("$HOME/.local/bin/limos-changevolume mute")),             -- Mute volume
        ((modm              , xK_z), spawn ("$HOME/.local/bin/limos-powermenu")),                                 -- Launch logout app
        ((0                 , xF86XK_AudioPrev), spawn ("$HOME/.local/bin/limos-mediactrl prev")),   -- Play prev spotify song
        ((0                 , xF86XK_AudioNext), spawn ("$HOME/.local/bin/limos-mediactrl next")),   -- Play next spotify song
        ((0                 , xF86XK_AudioPlay), spawn ("$HOME/.local/bin/limos-mediactrl toggle")), -- Play next spotify song
        ((0                 , xK_Print), spawn ("flameshot gui"))                                           -- Take a screenshot 
    ]
    ++
    [
        ((m .|. modm, k), windows $ f i) | 
        (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9], -- mod-[1..9], Switch to workspace N
        (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]    -- mod-shift-[1..9], Move client to workspace N
    ]
    -- For two monitor setup
    -- Workspaces 7 to 9 opens on left monitor rest on the right
    -- ++
    --[
    --    ((modm, k), windows (viewOnScreen sc ws)) |
    --    (ws, k, sc) <- zip3 (map show [1..6] ++ map show [7..9]) [xK_1..xK_9] (replicate 6 1 ++ replicate 4 0)
    --]
    -- ++
    --[ 
    --    ((modm .|. shiftMask, k), windows (W.shift ws)) |
    --    (ws, k) <- zip (map show [1..9]) [xK_1..xK_9]
    --]
    ++
    [
        ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f)) | 
        (key, sc) <- zip [xK_w, xK_e, xK_r] [0..],                                -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
        (f, m) <- [(W.view, 0), (W.shift, shiftMask)]                             -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    ]


-- Mouse bindings
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
        ((modm, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)),  -- mod-button1, Set the window to floating mode and move by dragging
        ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),                       -- mod-button2, Raise the window to the top of the stack
        ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)) -- mod-button3, Set the window to floating mode and resize by dragging
    ]


--Layout specifiers
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled  = limitWindows 12 $ ResizableTall nmaster (delta) ratio []

     nmaster = 1     -- The default number of windows in the master pane
     ratio   = 1/2   -- Default proportion of screen occupied by master pane
     delta   = 3/100 -- Percent of screen to increment by when resizing panes

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ 
     (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
    , className =? "MPlayer"                 --> doFloat
    , resource  =? "pavucontrol"             --> doCenterFloat
    , resource  =? "desktop_window"          --> doIgnore
    , resource  =? "kdesktop"                --> doIgnore 
    , isFullscreen -->  doFullFloat
    ]


--Executes every time xmonad starts
myStartupHook = do
  spawnOnce "dunst &"
  spawnOnce "udiskie --tray &"
  spawnOnce "xfce4-power-manager &"
  spawnOnce "nm-applet &"
  spawnOnce "flameshot &"
  spawn "$HOME/.config/polybar/launch.sh"

--Gaps between windows
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

--Main function
main :: IO()
main = do
  xmonad $ docks $ ewmh . ewmhFullscreen $ def
      {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = mySpacing 5 $ smartBorders $ myLayout,
        manageHook         = myManageHook ,
        startupHook        = myStartupHook
      }
