//Sends the leader board every frame
void sendLeaderBoard()
{
  //Sorts all players in order of number of kills
  PriorityQueue<Player> leaders = new PriorityQueue<>();
  
  for(int k: players.keySet())
    leaders.add(players.get(k));
  
  String toRet = "Player Num:    Kills:|";;
  
  //Sort through all players
  while(!leaders.isEmpty())
  {
    Player player = leaders.remove();
    toRet += player.ID + "                 " + player.kills + "|";
  }
  
  server.write("RANKINGS|" + toRet + "\n");
}
