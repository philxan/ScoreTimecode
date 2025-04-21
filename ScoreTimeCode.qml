import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import MuseScore
import Muse.UiComponents

//=============================================================================
// MuseScore 4.4+
//
// Score Timecode
// A plugin to display the time passed throughout the score
//
// (C) 2025 Phil Kan 
// PitDad Music. All Rights Reserved. GPL3 License. 
// 
// To Do 
// - Better Layout of buttons 
// 
// Change History
// v1.0 - Initial development
// 
//=============================================================================

MuseScore 
{
  version: "1.0"
  
  title: "Score Timecode"
  description: "This plug-in adds text to each measure to display the elapsed time in minutes, seconds, and milliseconds."
  pluginType: "dialog"
  thumbnailName: "ScoreTimecodeIcon.png"
  
  implicitHeight: 350;
  implicitWidth: 300;
 

//=============================================================================
// configuration options. 
//
// These can be set in the Main UI
  property var offsetTimeText: "00:00.000";    // seconds.milliseconds  
  property var offsetTime: 0.0
  property var excludeFirstMeasure: false;
  property var alwaysIncludeMinutes: false;
  property var italicText: false;
  property var boldText: false;
  property var borderText: false;
  property var underlineText: false;    
  property var aboveText: false  
                                      
//=============================================================================
// Main UI Layout
//

  SystemPalette { id: palette; colorGroup: SystemPalette.Active }

  GridLayout 
  {
    id: scoreTimeMainLayout
    columns: 2
    rowSpacing: 0
    anchors.fill: parent
    anchors.leftMargin: 5
    anchors.rightMargin: 5
    
    RowLayout 
    {
      id: offsetRow
      Layout.columnSpan:2
    
      Label 
      {
        id: offsetTimeLabel
        font.bold: true
        color: palette.text  
        text: "Offset time"
      }
          
      Item
      {
        id: offsetSpacerItem
        Layout.fillWidth: true
      }
      
      TextField 
      {
        id: offsetTimeField
        text: offsetTimeText
        Layout.maximumWidth:100      
        horizontalAlignment: TextInput.AlignRight
        Layout.alignment: Qt.AlignRight
        
        validator: RegularExpressionValidator { regularExpression: /^((\d{1,2}):(\d{1,2}).(\d{1,3}))$/ }
      }
    }

    Label 
    {
      id: offsetTimeDescription
      Layout.columnSpan:2
      font.italic: true
      color: palette.text  
      text: "Time code at which to start in mins:secs:millisecs.\nDefault: 00:00.000"
    }
    
    CheckBox 
    {
      id: excludeFirstMeasureCheckbox
      Layout.columnSpan:2
      text: "Exclude the first measure"
      checked: excludeFirstMeasure
      onClicked: { 
        excludeFirstMeasure = !excludeFirstMeasure; 
      }
    }
    
    CheckBox 
    {
      id: alwaysIncludeMinuteCheckbox
      Layout.columnSpan:2
      text: "Always include minutes"
      checked: alwaysIncludeMinutes
      onClicked: { 
        alwaysIncludeMinutes = !alwaysIncludeMinutes; 
      }
    }

    Label 
    {
      id: styleLabel
      Layout.columnSpan: 2
      Layout.topMargin: 10
      color: palette.text  
      text: "Style:"
    }
    
    RowLayout
    {
      id: styleRow
      Layout.columnSpan: 2
      Layout.leftMargin: 10
      Layout.rightMargin: 10
      width:parent.width
      
      RoundButton 
      {
        id: boldButton
        radius: 5
        text: "B"
        font.bold: true
        palette.buttonText: palette.text
        checkable: true
        checked: boldText
        onClicked: { 
          boldText = !boldText; 
        }
      }
      
      RoundButton 
      {
        id: italicButton
        radius: 5
        text: "I"
        font.italic: true
        palette.buttonText: palette.text
        checkable: true
        checked: italicText
        onClicked: { 
          italicText = !italicText; 
        }
      }
      
      RoundButton 
      {
        id: underlineButton
        radius: 5
        text: "U"
        font.underline: true
        palette.buttonText: palette.text
        checkable: true
        checked: underlineText
        onClicked: { 
          underlineText = !underlineText; 
        }
      }
      
      RoundButton 
      {
        id: borderButton
        radius: 5
        text: "[0]"
        palette.buttonText: palette.text
        checkable: true
        checked: borderText
        onClicked: { 
          borderText = !borderText; 
        }
      }
      
      SpinBox 
      {
        id: fontSizeSpinBox
        from: 1
        value: 9
        to: 99
        editable: true
        palette.buttonText: palette.text

        property string suffix: "pt"

        validator: RegularExpressionValidator { regularExpression: /\D*(-?\d*\.?\d*)\D*/ }

        textFromValue: function(value, locale) {
            return Number(value).toLocaleString(locale, 'f', 0) + suffix
        }

        valueFromText: function(text, locale) {
            let re = /\D*(-?\d*\.?\d*)\D*/
            return Number.fromLocaleString(locale, re.exec(text)[1])
        }
      }      
    }
    
    ButtonGroup
    {
      id: positionGroup
    }
    
    ButtonGroup
    {
      id: textStyleGroup
    }

    RowLayout
    {
      id: positionRow
      Layout.columnSpan: 2
      Layout.leftMargin: 10
      Layout.rightMargin: 10
      
      RoundButton 
      {
        id: aboveButton
        radius: 5
        text: "Above"
        palette.buttonText: palette.text
        checkable: true
        ButtonGroup.group: positionGroup
      }
      
      RoundButton 
      {
        id: belowButton
        radius: 5
        text: "Below"
        palette.buttonText: palette.text
        checkable: true
        checked: true
        ButtonGroup.group: positionGroup
      }
      
      Item
      {
        id: positionRowSpacerItem
        Layout.fillWidth: true
      }
      
      RoundButton 
      {
        id: quotesButton
        radius: 5
        text: "0'00.000"
        palette.buttonText: palette.text
        checkable: true
        ButtonGroup.group: textStyleGroup
        Layout.alignment: Qt.AlignRight
      }

      RoundButton 
      {
        id: colonsButton
        radius: 5
        text: "00:00.000"
        palette.buttonText: palette.text
        checkable: true
        checked:true
        ButtonGroup.group: textStyleGroup
      }
      
    }
    
    Row
    {
      id: buttonsRow
      Layout.columnSpan: 2
      
      spacing: 5
      topPadding: 10
      rightPadding: 10
      bottomPadding: 5

      RoundButton 
      {
        id: applyButton
        text: qsTranslate("PrefsDialogBase", "Apply")
        font.bold: true
        palette.buttonText: palette.text
        radius: 5
        onClicked: addScoreTimes()
      }
           
      RoundButton 
      {
        id: aboutButton
        text: "About"
        palette.buttonText: palette.text
        radius: 5
        onClicked: aboutDialog.open()
      }
      
    }
  }    
  
//=============================================================================
// About Dialog

  property string aboutDialogText: "
    <h3>Score Timecode</h3>
    <p>
    A MuseScore Studio plugin that adds the elapsed time in seconds to each measure
    </p>
    <p>
    GPLv3 License <br>
    (C) 2025 Phil Kan <br>
    PitDad Music. All Rights Reserved. 
    </p>
    </p>
    Details available on <a href='https://github.com/philxan/ScoreTimecode'>Github</a>
  "
  
  property string linkText: "https://github.com/philxan/ScoreTimecode"
  
  Dialog {
    id: aboutDialog
    title: "About Score Timecode"
    anchors.centerIn: parent
    palette.buttonText: palette.text
    standardButtons: Dialog.Ok 
    implicitWidth: Math.round(parent.width * 90 / 100)
    implicitHeight: Math.round(parent.height * 90 / 100)
    
    contentItem: Column {
      
      Rectangle {
        id: aboutContentRectangle
        color: "#ffffff"
        width: aboutDialog.contentItem.width
        height: aboutDialog.contentItem.height
        
          Text {
            id: aboutTextControl
            text: aboutDialogText
            anchors.fill: parent
            anchors.margins: 20
            onLinkActivated: Qt.openUrlExternally(linkText)
            wrapMode: Text.Wrap
            textFormat: Text.StyledText
            
            MouseArea 
            {
              anchors.fill: parent
              acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
              cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }
        }
      }
    }
  }    
  
  function displayError(message)
  {
    errorDialog.text = message;
    errorDialog.open();
  }

//=============================================================================
// errorDialog
  MessageDialog 
  {
    id: errorDialog
    visible: false
    title: "Score Times"
    text: ""
    onAccepted: {
      close();
    }
  }

//=============================================================================

  onRun: 
  {
    if ((mscoreMajorVersion < 4) || ((mscoreMajorVersion == 4 && mscoreMinorVersion < 4 ))) 
    {
      versionError.open()
      (typeof(quit) === 'undefined' ? Qt.quit : quit)()
      return;
    }
 
    setDefaults();
  }
    
//=============================================================================

  function addScoreTimes()
  {
  
    if (!validateOffsetTime())
    {
console.log("Error: Invalid Offset Time.")
      displayError("Error: The entered Offset Time is invalid.");
      return;
    }
  
    var cursor = getCursor();
    
    if (!cursor.segment )        // no selection
    { 
console.log("Error: Nothing is selected.")
      displayError("Error: Nothing is selected.\nPlease select one staff of bars with chords");
      return;
    }
    
    if (curScore.selection.endStaff - curScore.selection.startStaff > 1)
    {
console.log("Error: More than one staff selected")    
      displayError("Error: More than one staff is selected\nPlease select only one staff, with chords");
      return;
    }

    var endTick = getEndTick(cursor);
    
    // what ticks are the tempo changes
    var changes = getTickTempoChanges(cursor, endTick)
    var tickChanges = objectKeys(changes);
    var changesKey = 0;
    var currentTempo = changes[tickChanges[changesKey]];  // the first tempo
    
    var startTick = cursor.tick;
    var lastMeasureTick = startTick;
    
    var nextChangeTick = -1;
    var nextChangeTempo = -1;
    
    changesKey++;
    if (changesKey < tickChanges.length)
    {
      nextChangeTick = tickChanges[changesKey];
      nextChangeTempo = changes[nextChangeTick];
    }
    
    curScore.startCmd()
    
    var lastMeasureSeconds = offsetTime;
    if (!excludeFirstMeasure) 
    {
      addTimeText(cursor, formatTime(lastMeasureSeconds))   // first one is always at the offsetTime
    }
    
    cursor.nextMeasure()
    
    while ((cursor.tick != 0) && (cursor.tick < endTick))
    { 
      var measureSeconds = 0;
      
      // a tempo change occured somewhere in the previous measure
      if ((lastMeasureTick <= nextChangeTick) && (nextChangeTick < cursor.tick))
      {
          // do it multiple times, in case there is more than one change!
        while ((lastMeasureTick <= nextChangeTick) && (nextChangeTick < cursor.tick)) 
        {
          
          // calculate from the lastMeasureTick, to the tempo change at the old tempo
          measureSeconds = lastMeasureSeconds + (nextChangeTick - lastMeasureTick) / (currentTempo * division);
          
          // tempo change!
          currentTempo = nextChangeTempo
          
          // add the time from the change, to the current tick, at the new tempo
          measureSeconds = measureSeconds + ((cursor.tick - nextChangeTick) / (currentTempo * division));
          
          // update the nextChangeTick & Tempo
          changesKey++;
          if (changesKey < tickChanges.length)
          {
            nextChangeTick = tickChanges[changesKey];
            nextChangeTempo = changes[nextChangeTick];
          }
          else
          {
            nextChangeTick = -1;
          } 
         
        }
      }
      else
      {
        // no tempo change encountered, so a lot easier to calculate!
        measureSeconds = lastMeasureSeconds + (cursor.tick - lastMeasureTick) / (currentTempo * division);
      }
      
      addTimeText(cursor, formatTime(measureSeconds))
      
      lastMeasureSeconds = measureSeconds;
      lastMeasureTick = cursor.tick;
      cursor.nextMeasure()

    }
    
    curScore.endCmd()
  }

  
//=============================================================================
// 
// returns an object of tick:tempo
// - tick: where the tempo change occurs
// - tempo: the number of quarternotes per second
// e.g a 4/4 tempo of 60 will return a "tempo" of 1, 120 -> 2 etc. 
// 
  function getTickTempoChanges(cursor, endTick)
  {
    var result = {}

    var startTick = cursor.tick
    
    // find the ticks where the tempo is different
    var currentTempo = 0;
    while (cursor.tick < endTick) 
    {
      if (cursor.tempo != currentTempo) 
      {
        result[cursor.tick] = cursor.tempo
        currentTempo = cursor.tempo 
      }
      if (!cursor.next()) break;
    }
    
    cursor.rewindToTick(startTick)
    
    return result;
  }

//=============================================================================
//
// returns the provided time in seconds as a string of "mm:ss.hhhh"
//

  function formatTime(seconds)
  {
    var minutes = Math.floor(seconds / 60);
    
    seconds = seconds - (minutes*60);

    var secondsPart = Math.floor(seconds);   
    secondsPart = (((minutes > 0 || alwaysIncludeMinutes) && secondsPart < 10) ? "0" : "") + secondsPart;
    
    seconds = seconds - Math.floor(seconds);
    var milliseconds = Math.round(seconds * 1000)
    
    while (milliseconds.toString().length < 3) milliseconds = "0" + milliseconds;
    
    var result = secondsPart + "." + milliseconds + '"';
    
    if (minutes > 0 || alwaysIncludeMinutes)
    {
      result = minutes 
        + (colonsButton.checked ? ":" : "'")
        + result;
    }
    
    return result;
  }


//=============================================================================
// 
  function addTimeText(cursor, timeString)
  {
    var text  = newElement(Element.STAFF_TEXT)
    text.text = timeString;

    text.fontSize = fontSizeSpinBox.value

    text.fontStyle = (boldText ? 1 : 0)           // MS::FontStyle.Bold
                      + (italicText ? 2 : 0)      // MS::FontStyle.Italic
                      + (underlineText ? 4 : 0);  // MS::FontStyle.Underline
                      
    text.frameType = (borderText ? 1 : 0);    // MS::FrameType.SQUARE

    text.placement = aboveButton.checked ? Placement.ABOVE : Placement.BELOW
    cursor.add(text);
  }
  
//=============================================================================

  function validateOffsetTime()
  {
    // try to parse the offsetTimeText into mm:ss:t[ttt]
    // set the offsetTime value to the seconds representation
    offsetTimeText = offsetTimeField.text

    offsetTime = 0;

    // Parse a offsetTimeText in format "MM:SS.HHH" (minutes:seconds:milliseconds)
    try 
    {
        // Check if it matches the format
        var regex = /^((\d{1,2}):(\d{1,2}).(\d{1,3}))$/;
        var timeStamp = offsetTimeText.match(regex);
        
        if (!timeStamp) return false;
        
        var minutes = parseInt(timeStamp[2]);
        var seconds = parseInt(timeStamp[3]);
        var millis = parseInt(timeStamp[4]);
        
        if (millis < 10) millis *= 10;    // 5 -> 50
        if (millis < 100) millis *= 10;   // 50 -> 500
        
        // Validate ranges
        if (seconds >= 60) {
            return false;
        }
          
        // Calculate total seconds
        offsetTime = (minutes * 60) + seconds + (millis / 1000);
        
    } 
    catch (e) 
    {
        return false;
    }
    
    return true;
  }

//=============================================================================

  function objectKeys(obj)
  {
    var result = []
    for (var key in obj)
    {
      result.push(key)
    }
    
    return result;
  }

//=============================================================================

  function getCursor()
  {
    var cursor = curScore.newCursor()
    cursor.staffIdx = 0;
    cursor.voice = 0;
    cursor.rewind(Cursor.SELECTION_START);
    
    return cursor;
  }

//=============================================================================

  function getEndTick(cursor)
  {
    cursor.rewind(Cursor.SELECTION_END);
    var endStaff = cursor.staffIdx;
    
    var endTick;
    
    if (cursor.tick == 0) {
      // this happens when the selection includes  the last measure of the score.
      // rewind(Cursor.SELECTION_END) goes behind the last segment (where there's none) and sets tick=0
      endTick = curScore.lastSegment.tick;
    } else {
      endTick = cursor.tick;
    }
    
    cursor.rewind(Cursor.SELECTION_START);
    return endTick;
  }
  
//=============================================================================

  function setDefaults()
  {
    elapsedTime = 0.0;
    
  }  

}
