// dMud by Mad Merv (madmerv@gmail.com) - Created 18 August 2005 with Processing
// Copyright (c) 2005 H. Gilliland; distributed under Creative Commons License
import java.net.*;

Mud mud = new Mud();
String WEB = param("host"); // value requires terminating slash (/)
int port= int(param("port")); 
ServerSocket socket = null;
boolean listening = true;

String result[] = null;  // result from query

 // Connected States for a Channel
final int PLAYING = -1;
final int TITLE = 0;
final int GET_NAME = 1;
final int GET_PASSWORD = 2;
final int GET_CONFIRM_NEW = 3;
final int GET_NEW_PASSWORD = 4;
final int GET_CONFIRM_PASSWORD = 5;
final int GET_SEX = 6;
final int GET_DISCIPLINE = 7;
final int GET_ROLL_STATS = 8;
final int MOTD = 10;

void setup() {
 size(256,256);
 textFont(loadFont("ScalaSans-Caps-32.vlw"));
 port=port>0?port:4444; WEB=WEB!=""&&WEB!=null?WEB:"http://localhost/"; // param() defaults
 // BIND  -> add param() support here
 try { socket = new ServerSocket(port); } catch (IOException e) {
   System.err.println("Could not listen on port: "+port);
   System.exit(-1);
  }
 println("Server bound to port: "+port);
 try { while (listening) { new Server(socket.accept()).start(); }
  } catch (IOException e) {
   System.err.println("Could not listen on port: "+port);
   System.exit(-1);
  }
 System.exit(0);
}

// Visualization
void draw() {
 background(int(random(255)));
 updatePixels();
}

// URL-safe encoder
String unsafe = " \"<>%^[]`+$,;?:@=&#/\\";

String URLencode(String v) {
 int len = v.length();
 String newStr  = "";
 for (int i=0;i<len;i++) {
  char c = v.charAt(i);
  if (int(c) < 255) {
   if (unsafe.indexOf(c) == -1 && int(c) > 32 && int(c) < 123) newStr = newStr + c;
    else newStr = newStr + "%" + hex(c,2);
  }
 }
 return newStr;
}

String direction( String dir ) {
 if ( dir.equals("n") ) return "north"; if ( dir.equals("s") ) return "south";
 if ( dir.equals("e") ) return "east";  if ( dir.equals("w") ) return "west";
 if ( dir.equals("u") ) return "up";    if ( dir.equals("d") ) return "down";
 return dir;
}

String reverse_direction( String dir ) {
 switch( dir.charAt(0) ) {
  case 'n':return "south"; case 's':return "north";
  case 'e':return "west";  case 'w':return "east";
  case 'u':return "down";  case 'd':return "up";
 }
 return dir;
}

// Word wrap (formats a string to 80 columns)
String wrap( String s ) {
 return s;
}

// Capitalizes name to Name
String capitalize( String s ) {
 String t=""+s.charAt(0);
 t=t.toUpperCase(); for ( int i=1; i<s.length(); i++ ) t+=s.charAt(i);
 return t;
}

// Server is a threaded server object that provides multi-state handling
// for client descriptors.
public class Server extends Thread implements Runnable {
 private Socket socket = null;

 public Server(Socket socket) {
  super("Server");
  this.socket = socket;
 }

 public void run() {
  try {
   PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
   BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

   String inputLine, inputLower, outputLine;
   Player player;
   mud.add(player=new Player());
   player.socket = socket;
   player.out = out;
   
   outputLine = player.processInput(null);
   out.println(outputLine);  outputLine="";
   while ((inputLine = in.readLine()) != null) {
    outputLine = player.processInput(inputLine);
    if ( player.output != null && player.output != "" )
     { out.write(player.output); player.output=""; }
    if ( outputLine != null ) { out.write(outputLine); 
    if ( inputLine.equalsIgnoreCase("quit") || outputLine.equals("Disconnect") ) break; } 
    out.flush();
   }
   out.close(); in.close(); socket.close(); mud.remove(player);
  } catch (IOException e) { e.printStackTrace(); }
 }
}

// Mud class
public class Mud {
 Player player[]=null;
 Mob mob[]=null;
 Obj obj[]=null;
 int players=0,objs=0,mobs=0;

 void add( Mob m ) { mobs++;
  Mob[] q=new Mob[mobs];
  for(int i=0;i<mobs-1;i++) q[i]=mob[i];
  q[mobs-1]=m;
  mob=q;
 }

 void add( Obj o ) { objs++;
  Obj[] q=new Obj[objs];
  for(int i=0;i<objs-1;i++) q[i]=obj[i];
  q[objs-1]=o;
  obj=q;
 }

 void add( Player p ) { players++;
  Player[] q=new Player[players];
  for(int i=0;i<players-1;i++) q[i]=player[i];
  q[players-1]=p;
  player=q;
 }
 
 void remove( Player p ) {
  Player[] q=new Player[players]; int i;
  for(i=0;i<players-1;i++) if (player[i]!=p) { q[i]=player[i]; } else break;
  for( ; i<players-2; i++ ) q[i]=player[i+1];
  players--;
 }
 
 void remove( Mob m ) {
  Mob[] q=new Mob[mobs]; int i;
  for(i=0;i<mobs-1;i++) if (mob[i]!=m) { q[i]=mob[i]; } else break;
  for( ; i<mobs-2; i++ ) q[i]=mob[i+1];
  mobs--;
 }
 
 void remove( Obj o ) {
  Obj[] q=new Obj[objs]; int i;
  for(i=0;i<objs-1;i++) if (obj[i]!=o) { q[i]=obj[i]; } else break;
  for( ; i<objs-2; i++ ) q[i]=obj[i+1];
  objs--;
 }
 
 // global echo to all connected players playing
 void echo( String msg ) {
  for(int i=0;i<players-1;i++) if ( player[i].state == PLAYING )
  player[i].output+=msg;
 }

 // room-specific echo
 void echo( String msg, int loc ) {
  for(int i=0;i<players-1;i++) if ( player[i].state == PLAYING && player[i].location==loc )
  player[i].output+=msg;
 }
   
// void combat( ) { for(int i=0; i<players-1; i++) player.oroc(); }
}

// Mob Class
public class Mob {
 String name;
 int vnum,level,location,hp;
 Player fighting=null;
 boolean wanderer=false,aggressive=false;
 
 void Mob( ) { }
 void Mob( int v ) { vnum=v; }

 void wander() {
  result = loadStrings(WEB+"exits.php?loc="+location);
  mud.echo( name+" has departed.\n\r", location );
  location = int(result[int(random(6))]);  // 6="Exit Resolution" u,d,n,s,e,w
  mud.echo( name+" has arrived.\n\r", location );
 }
 
 void aggressive() {
 }
 
 void load( String v ) {
  result=loadStrings(WEB+"mob.php?v="+v);
//  result = split(result[0], "|");
//  vnum = int(v); hp = int(result[1]); level = int(result[2]);
//  location = int(result[3]); wanderer = int(result[4])>0; aggressive = int(result[5])>0;
 }
 
 void load( int v ) {
  result = loadStrings(WEB+"mob.php?v="+v);
//  result = split(result[0], "|");
//  vnum = v; name = result[1]; level = int(result[2]); value = int(result[3]);
//  level = int(result[4]);
 }
 
 void evolve( ) {
  String buffer[]=loadStrings(WEB+"evolve.php?v="+vnum+"&n="+name+"&lv="+level+"&w="+wanderer+"&a="+aggressive);
 }
 
 void create( ) {
 }
}

// Obj Class
public class Obj {
 String name;
 int vnum,type,value,level,location;

 void Obj ( ) { }
 void Obj ( int v ) { vnum=v; }
  
 void load( String v ) {
  result=loadStrings("obj.php?v="+v); 
  result = split(result[0], "|");
  vnum = int(v); name = result[1]; type = int(result[2]); value = int(result[3]); level = int(result[4]);
 }
 
 void load( int v ) {
  result=loadStrings("obj.php?v="+v);
  result= split(result[0], "|");
  vnum = v; name = result[1]; type = int(result[2]); value = int(result[3]); level = int(result[4]);
 }
 
 void design( ) {
  result=loadStrings("design.php?v="+vnum+"&n="+name+"&t="+type+"&va="+value+"&lv="+level);
 }

 void create( ) {
 }  
}

// Player Class                                                             
// This protocol class is the "main loop" for each connection to the mud. 
public class Player {
 // Stream handling
 String buffer[] = null;
 String output="";
  
 private int state = TITLE;

// Player attributes
  public String name;
 private String password = "<none>";
 private int retries=0;
  public boolean wizard = false;
  public boolean male = false;
  public String discipline = "commoner";
  public int strength;
  public int intelligence;
  public int wisdom;
  public int dexterity;
  public int constitution;
  public int charisma;
  public int xp;
  public int level;
  public int gold;
  public int hp;
  public int mana;
  public int damroll;
  public int hitroll;
  public int ac;
  public int location;      // vnum ref
  public String inventory;
  public String equipment;
  public String prompt="> ";
  Socket socket;
  PrintWriter out;
  Mob fighting=null;
   
// Writes the player to the database; 
// max URL is 2048 on some browsers, so short variable names
 private void saveme( ) {
  buffer = loadStrings(WEB+(state==PLAYING?"save_player.php":"new_player.php")+
  "?n="+name+"&p="+password+"&wiz="+(wizard?1:0)+"&g="+(male?1:0)+"&d="+discipline+
  "&s="+strength+"&i="+intelligence+"&w="+wisdom+"&de="+dexterity+
  "&co="+constitution+"&ch="+charisma+"&e="+xp+"&l="+level+
  "&g="+gold+"&hp="+hp+"&m="+mana+"&dr="+damroll+"&hr="+hitroll+
  "&ac="+ac+"&lo="+location ); println(join(buffer," "));
 }
 
 // Display stats    
 public String stats( ) {
  return
      "Strength:     " + strength +
  "\n\rIntelligence: " + intelligence +
  "\n\rWisdom:       " + wisdom +
  "\n\rDexterity:    " + dexterity +
  "\n\rConstitution: " + constitution +
  "\n\rCharisma:     " + charisma;
 }
 
 public String score( ) {
 return "\n\r" + "Level "+level+", "+xp+" experience, "+1024*level+"to next\n\r"+
  hp+" hit points of "+constitution*level+", armor class "+ac+"\n\r"+
  mana+" mana points of "+((wisdom+intelligence)/2)*level+"\n\r"+
  gold+" gold pieces";
 }

 // Roll statistics
 private void roll( ) {
  strength    =int(random(18));
  intelligence=int(random(18));
  dexterity   =int(random(18));
  wisdom      =int(random(18));
  constitution=int(random(18));
  charisma    =int(random(18));    
 }

 public String processInput(String theInput) {
  String theOutput = null;
//  println(" State: " + state + " \"" + theInput + "\"" );
  switch (state) {
   case TITLE: 
        buffer = loadStrings(WEB+"title.txt");
        theOutput = join(buffer,"\n\r");
        state = GET_NAME;
    break;
   case GET_NAME:
        if ( theInput == "" || theInput.length() < 3 ) theOutput = "Invalid name.  Please enter your name: ";
        else {
         name = capitalize(trim(theInput));
         for ( int i=0; i<mud.players; i++ )
         if ( mud.player[i].name.equals(name) && mud.player[i] != this ) { out.println("Already playing, cannot connect.\n\r"); out.flush(); return "Disconnect"; }
         buffer = loadStrings(WEB+"load_player.php?name="+name); 
         buffer[0] = trim(buffer[0]);
         debug();
         if ( buffer[0].equals("NEW") ) { theOutput = "Create as new? (y/n) "; state = GET_CONFIRM_NEW;  }
         else { // load existing player
          buffer = split(buffer[0],"|");
          password    =buffer[1];           wizard      =int(buffer[2])!=0;
          male        =int(buffer[3])!=0;   discipline  =buffer[4];
          strength    =int(buffer[5]);      intelligence=int(buffer[6]);
          wisdom      =int(buffer[7]);      dexterity   =int(buffer[8]);
          constitution=int(buffer[9]);      charisma    =int(buffer[10]);
          xp          =int(buffer[11]);     level       =int(buffer[12]);
          gold        =int(buffer[13]);     hp          =int(buffer[14]);
          mana        =int(buffer[15]);     damroll     =int(buffer[16]);
          hitroll     =int(buffer[17]);     ac          =int(buffer[18]);
          location    =int(buffer[19]);     theOutput = "Password: ";
          state = GET_PASSWORD;
         }
        }
     break;
   case GET_PASSWORD: 
        if ( theInput.equals(password) ) {
         theOutput = "Password accepted.\n\r";
         buffer = loadStrings(WEB+"motd.txt");
         theOutput = join(buffer,"\n\r");                  
         state = MOTD;                     
        } else if ( ++retries < 3 ) theOutput = "Password invalid.  Retry: ";
        else theOutput = "Disconnect";
     break;
   case GET_CONFIRM_NEW: 
        theInput = theInput.toLowerCase();
        if ( theInput.indexOf('y') == 0 )  {
         buffer = loadStrings(WEB+"new.txt");
         theOutput = join(buffer,"\n\r") + "Enter a password for your character: ";
         state = GET_NEW_PASSWORD;
        } else { theOutput = "Enter your name: "; state=GET_NAME; }
     break;
   case GET_NEW_PASSWORD: 
        password = theInput; theOutput = "Please re-enter password for verification: ";
        state = GET_CONFIRM_PASSWORD;
     break;
   case GET_CONFIRM_PASSWORD: 
        if ( theInput.equals(password) ) {
         theOutput = "Password confirmed.\n\rIs your character male or female? ";
         state = GET_SEX;
        } else {
         theOutput = "Passwords do not match.  Enter your password: ";
         state = GET_NEW_PASSWORD;
        }
     break;
   case GET_SEX: 
        theInput = theInput.toLowerCase();
        theOutput = "Choose your discipline: Mage, Warrior, Thief, Cleric\n\r";        
        if ( theInput.indexOf('m') == 0 )  { male = true; state = GET_DISCIPLINE; }
   else if ( theInput.indexOf('f') == 0 )  { male = false; state = GET_DISCIPLINE; }
        else theOutput = "Invalid response.  Male or female? ";
     break;
   case GET_DISCIPLINE: 
        roll();
        theOutput = "Rolling dice...\n\r" + stats() + "\n\rAccept these stats (y/n)? ";
        theInput = theInput.toLowerCase();
        if ( theInput.indexOf('m') == 0 )  { discipline = "mage"; state = GET_ROLL_STATS; }
   else if ( theInput.indexOf('w') == 0 )  { discipline = "warrior"; state = GET_ROLL_STATS; }
   else if ( theInput.indexOf('t') == 0 )  { discipline = "thief"; state = GET_ROLL_STATS; }
   else if ( theInput.indexOf('c') == 0 )  { discipline = "cleric"; state = GET_ROLL_STATS; }
      else { theOutput = "Invalid selection.\n\r" +
             "Please choose from one of the following:\n\r" +
             "Mage, Thief, Warrior, Cleric\n\rSelection: "; }
     break;
   case GET_ROLL_STATS:
        if ( theInput.indexOf('y')!=0 ) {
         roll(); 
         location=1;
         theOutput = "Rolling dice...\n\r" + this.stats() + "\n\rAccept these stats (y/n)? ";
        }  else { // Save new player and display MOTD
         saveme();
         buffer = loadStrings(WEB+"motd.txt");
         theOutput = join(buffer,"\n\r");                  
         state=MOTD;                     
        }
     break;
   case MOTD: theOutput=look(); state = PLAYING; break;
   case PLAYING: theOutput = parser(theInput); break;
    default: break;
  }
  return theOutput;
 }
    
 String parser( String cl ) {
  buffer = split(cl," ");  // could split by ; and use for() for cmd;cmd;cmd prm;cmd
  if ( buffer.length == 0 ) return "";
  // short commands -> full word commands
  buffer[0]=direction(buffer[0]);

  if ( buffer[0].equals("north") || buffer[0].equals("south") ||
       buffer[0].equals("east" ) || buffer[0].equals("west" ) ||
       buffer[0].equals("up"   ) || buffer[0].equals("down" ) ) return move( buffer[0] );
  else if ( buffer[0].equals("stats") || buffer[0].equals("status") )
   return name+" the "+discipline+"\n\r"+stats()+score();
  else if ( buffer[0].equals("who") ) return who();
  else if ( buffer[0].equals("tell") && buffer.length>1 ) return tell( buffer[1] );
  else if ( buffer[0].equals("say") && buffer.length>1 ) return say( );
  else if ( buffer[0].equals("look") || buffer[0].equals("l") ) return ( buffer.length > 1 ? look(buffer[1]) : look() );
  else // OLC commands
  if ( buffer[0].equals("teleport") && buffer.length>1 ) return teleport( buffer[1] );
  else if ( buffer[0].equals("dig") ) return dig();
  else if ( buffer[0].equals("connect") && buffer.length >2 ) return connect( buffer[1], buffer[2] );
  else if ( buffer[0].equals("disconnect") && buffer.length>1 ) return disconnect( buffer[1] );
  else
  if ( buffer[0].equals("quit") ) { saveme(); return join(loadStrings(WEB+"goodbye.txt"),"\n\r"); }
  else // Help command
  if ( buffer[0].equals("help") || buffer[0].equals( "?" ) ) {
   if ( buffer.length>1 ) return join(loadStrings(WEB+"help/"+buffer[1]+".txt"),"\n\r");
   else return join(loadStrings(WEB+"help/help.txt"),"\n\r")+(wizard?"\n\r"+join(loadStrings(WEB+"wizards.txt"),"\n\r"):"");
   }
  else return "Huh?\n\r";
 }

// Commands:

 // who
 String who( ) {
  String s="";
  for ( int i=0; i<mud.players; i++ )
  s = s + mud.player[i].name + (mud.player[i].wizard?"*":"") + "\n\r";
  s = s + mud.players + " total players online\n\r\n\r";
  return s;
 }

 // kill <target>
 String kill( ) { return ""; }
 
 // tell <target> <message>
 String tell( String target ) {
  buffer[0] = "";  buffer[1] = ""; buffer[0] = trim(join(buffer," "));  // trick
  for ( int i=0; i<mud.players; i++ )
  if ( mud.player[i].name.equalsIgnoreCase(target) ) {
   mud.player[i].out.println(name+" tells you: \""+buffer[0]+"\"\n\r"); 
   mud.player[i].out.flush();
   return "You tell "+mud.player[i].name+": "+buffer[0]+"\n\r";
  }
  return "Who?\n\r";
 }

 // say <message>
 String say( ) {
  buffer[0] = ""; buffer[0] = trim(join(buffer," "));  // trick
  for ( int i=0; i<mud.players; i++ )
  if ( mud.player[i].location == location && mud.player[i] != this ) {
   mud.player[i].out.println(name+" says, \""+buffer[0]+"\"\n\r"); 
   mud.player[i].out.flush();
   return "You say "+mud.player[i].name+", \""+buffer[0]+"\"\n\r";
  }
  return "Who?\n\r";
 }
        
 // look
 String look( ) {
  buffer = loadStrings(WEB+"scene.php?loc="+location);
  if ( buffer[0].equals("NONE") ) { location=1; buffer = loadStrings(WEB+"scene.php?loc="+location); }       
  buffer = split(buffer[0],"|");
  return buffer[0]+(wizard?(" #"+location):"")+"\n\r"+wrap(buffer[1])+"\n\r";
 }

 // look <direction|object|actor>        
 String look( String target ) {
  return "";
 }

 // move 
 String move( String dir ) {
  int dest;
  buffer = loadStrings(WEB+"exit.php?loc="+location+"&dir="+dir); dest=int(buffer[0]);
  buffer = loadStrings(WEB+"scene.php?loc="+dest);
  if ( buffer[0].equals("NONE") ) return "You cannot go that way.\n\r"; 
  location = dest;
  return look();
 }
 
 // teleport <location>
 String teleport( String dest ) { if (!wizard) return "What?\n\r";
  buffer = loadStrings(WEB+"scene.php?loc="+dest);
  if ( buffer[0].equals("NONE") ) return "That place doesn't exist.\n\r"; 
  location = int(dest);
  return look();
 }

 // dig
 String dig( ) { if ( !wizard ) return "What?\n\r";
  buffer = loadStrings(WEB+"dig.php"); debug();
  location = int(buffer[0]);
  return "Dug.\n\r";
 }

 // connect <direction> <destination>
 String connect( String dir, String dest ) { if (!wizard) return "What?\n\r";
  String rev_dir = "";
  buffer = loadStrings(WEB+"scene.php?loc="+dest);
  if ( buffer[0].equals("NONE") ) return "Destination does not exist.";
  dir=direction(dir); rev_dir=reverse_direction(dir);
  buffer = loadStrings(WEB+"update.php?l=1&t=scenes&c="+dir+"&v="+dest+"&s=loc&k="+location );
  buffer = loadStrings(WEB+"update.php?l=1&t=scenes&c="+rev_dir+"&v="+location+"&s=loc&k="+dest );
  return "Connected.\n\r";
 }

 // disconnect <direction>
 String disconnect( String dir ) { if (!wizard) return "What?";
  String rev_dir = "";
  int dest;
  buffer = loadStrings(WEB+"exit.php?loc="+location+"&dir="+dir); dest=int(buffer[0]);
  buffer = loadStrings(WEB+"scene.php?loc="+dest);
  if ( buffer[0].equals("NONE") ) return "Destination does not exist.\n\r";
  dir=direction(dir); rev_dir=reverse_direction(dir);
  buffer = loadStrings(WEB+"update.php?l=1&t=scenes&c="+dir+"&v="+0+"&s=location&k="+location );
  buffer = loadStrings(WEB+"update.php?l=1&t=scenes&c="+rev_dir+"&v="+0+"&s=location&k="+dest );
  return "Disconnected.\n\r";
 }
 
 // evolve <name>
 String evolve( String name ) { if (!wizard) return "What?\n\r";
  buffer = loadStrings(WEB+"evolve.php?name="+name+"&level="+level);
  return "Evolved.\n\r";
 }
 
 // design <name> <type>
 String design( String name, String type ) { if (!wizard) return "What?\n\r";
  buffer = loadStrings(WEB+"design.php?name="+name+"&type="+type+"&level="+level);
  return "Designed.\n\r";
 }

 // cue <type> <number> <frequency>
 String cue( String type, String number, String frequency ) { return ""; }

 // debug() function for outputing the buffer, this function
 // is useful for debugging php / mysql queries
 void debug() { println("\""+join(buffer,"")+"\""); }
}
