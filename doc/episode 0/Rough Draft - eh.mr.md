(`.mr` stands for machine readable)

```
#abstract types (one stack for each type, plus one stack for call/return)
{
    Mevent {
        port : string,
        payload : string
    }

    //
    Wire {
        direction: one of [ "down" | "across" | "up" | "through" ],
        sender: { instance, port },
        receiver : { instance, port }
    }

    Eh {
        inq : Queue,
        outq : Queue,
        state: one of ["idle" | "active"]
    }

    Container {
        children: collection [eh],
        routingTable : collection [Wire]
        ready-list: Queue
    #design rules
        sender is in children or is self
        receiver is in children or is self
    }

    int { #builtin }
    controlflow { #builtin }
    child { #type Eh }
}

#external types
{
    Queue: reset[-|-], append[Mevent|-], take[-|Mevent], length[-|int],
          discard [-|-]
}

#subroutines
{
  Container/handler {
    #sig [Eh, Mevent | Eh, Mevent] []
    #design rule
        eh is a Container
    #operation
    {
        for every child in Eh.ready-list in order { 
            child/push ready-list«eh»/take
            invoke child
        }
    }
    #finally
        Eh/pop
        Mevent/pop
  }

  Container/reset {
    #sig in (eh), consumes (eh)
    #design rule
        eh is a Container
    #operation
    {
     reset
    }
    #finally
        Eh/pop
  }

  Eh/replace { -- replaces Eh[] with given value }

  Eh/send {
    #sig
      in (Eh Port Payload cause)
      consumes (Eh Port Payload cause)
      uses 1 Mevent
    #design rule
      cause : Mevent  
    #operation
      {
          if Eh[].parent {
              Eh/replace Eh[].parent
              Eh/send
          } else {
              Eh[].outq/append Mevent/new (port, m)
          }
      }

  Eh/invoke child {
    #sig
      in (parent child Mevent)
      consumes (child Eh Mevent)
      uses ???
    #design rule
      parent : Eh
      child : Eh
      child / inq not empty
    #operation
        {
            child/handle
            child/distribute outputs
            when child/active? { send tick to child ; parent.ready-list/append child }
        }
  }

  Eh/distribute outputs {
    #sig
      in child
      consumes -
      uses ???
    #design rule
    #operation
      {
            for every {Parent/find wire that has this child and port as the sender}
            {
                -- a wire has been pushed
                -- remap mevent to {receiver.port, payload}
                Port/push Wire[].receiver.port
                Payload/push child[].outq/peek.payload
                Eh/inject input
            }
          child[].outq/discard first mevent
        }    
    #final design rule
      child[].outq/output queue is empty?
    #final operation
    }

  Eh/inject from outside {
    #sig
      in Mevent, Eh
      consumes Mevent, Eh
      uses ???
    #design rule
    #operation
      {
        
      }
}




      
#Load templates {
  load Container parts from diagrams
  load Leaf parts
#Build top part {
  instantiate recursively from top part«top»
#Run top part {
  invoke «top» with «arg»
  finalize and print output queue of «top»  
}  
```