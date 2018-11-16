package dvs_msgs;

public interface Event extends org.ros.internal.message.Message {
  static final java.lang.String _TYPE = "dvs_msgs/Event";
  static final java.lang.String _DEFINITION = "# A DVS event\nuint16 x\nuint16 y\ntime ts\nbool polarity\n";
  static final boolean _IS_SERVICE = false;
  static final boolean _IS_ACTION = false;
  short getX();
  void setX(short value);
  short getY();
  void setY(short value);
  org.ros.message.Time getTs();
  void setTs(org.ros.message.Time value);
  boolean getPolarity();
  void setPolarity(boolean value);
}
