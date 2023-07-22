void sendLeaderBoard()
{
  PriorityQueue<Player> leaders = new PriorityQueue<>();
  
  for(int k: players.keySet())
  {
    leaders.add(players.get(k));
  }
  
  String toRet = "Player Num:    Kills:|";;
  
  while(!leaders.isEmpty())
  {
    Player player = leaders.remove();
    toRet += player.ID + "                 " + player.kills + "|";
  }
  
  server.write("RANKINGS|" + toRet + "\n");
}
