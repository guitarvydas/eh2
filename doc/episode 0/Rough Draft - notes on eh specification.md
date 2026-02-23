# Eh objects and Mevents
- messages are events
  - each message is processed by the receiver, in order of arrival
- mevents (aka "messages") contain two parts
  1. port (a string tag)
  2. payload (a string (bytes))
- eh objects are completely asynchronous, activated by a Dispatcher
- each eh object is an instance of an eh template (similar to objects instantiated from classes)
- each eh object contains any number (0 .. lots) of input ports
- each eh object contains any number (0 .. lots) of output ports
- an eh object does not return a value, it appends results, as mevents, to its own output queue
- eh Leaf objects do not directly reference other eh objects
- eh Container objects contain a collection of children eh objects and a collection of wires (connections between ehildren and themselves)
- each eh object contains exactly one input queue and exactly one output queue (not one queue per port, hence the tags on mevents)
- eh Container objects a like little dispatchers - they move mevents between their children (the children cannot move their own mevents)
- when a mevent is moved ("routed") between on eh's port to another eh's port, the mevent port is rewritten (mapped) from the senders output port name to the receiver's input port name
- eh Container objects can contain - recursively - other eh objects (Leaf and Container eh objects)
- fan in, fan out
- handler
- atomic fan-out
- duck typing
- black boxes

# Dispatching rules
- async by default
- atomic fan-out

# Experiences
  - tried to create payloads containing data structures - not worth it, strings are fast on modern hardware
  - if you need to destructure a payload, use a PEG parser,
    - JIT destructuring only, AOT requires central knowledge of structuring
