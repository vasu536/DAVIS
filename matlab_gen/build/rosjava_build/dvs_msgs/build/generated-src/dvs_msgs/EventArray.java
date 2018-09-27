package dvs_msgs;

public interface EventArray extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "dvs_msgs/EventArray";
  static final java.lang.String _DEFINITION = "# This message contains an array of events\n# (0, 0) is at top-left corner of image\n#\n\nHeader header\n\nuint32 height         # image height, that is, number of rows\nuint32 width          # image width, that is, number of columns\n\n# an array of events\nEvent[] events\n";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  std_msgs.Header getHeader();
  void setHeader(std_msgs.Header value);
  int getHeight();
  void setHeight(int value);
  int getWidth();
  void setWidth(int value);
  java.util.List<dvs_msgs.Event> getEvents();
  void setEvents(java.util.List<dvs_msgs.Event> value);
}
