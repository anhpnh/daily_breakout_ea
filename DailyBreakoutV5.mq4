#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.05"
#property strict
//--- input parameters
extern string   Scalping="";//D1, W1, MN1 Breakout Scalping
extern bool D1=true;//Trade D1
extern bool W1=false;//Trade W1
extern bool MN1=false;//Trade MN1
extern double   Lot=0.01;//Lot Static
extern double   SL=5.0;//Stoploss
extern double   TP=15.0;//Takeprofit
extern bool     TrailingStop=true;//TrailingStop
extern int      Step=5;//Step
extern bool     UseRiskPercent=true;//UseRiskPercent
extern double   MaxLot=1.0;//MaxLot
extern double   RiskPercent=1.0;//% AccountBalance
extern int      Magic=123456789;//Magic Number
extern string    Comm="Daily Breakout";//Comment
extern bool      Monday=true;//Monday
extern bool      Tuesday=true;//Tuesday
extern bool      Wednesday=true;//Wednesday
extern bool      Thursday=true;//Thursday
extern bool      Friday=true;//Friday
extern bool      SendMessage=true;//Send message to mobile
datetime last;
double soTienRuiRo;
double lotGiaoDich;
int    D1Buy, D1Sell, W1Buy, W1Sell, MN1Buy, MN1Sell;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  if(Symbol() == "XAUUSDm" || Symbol() == "XAUUSD"){
            SL *= 10;
            TP *= 10;
            Step *= 10;
  }
   if(SendMessage == true)
      SendNotification("-EA OnInit AccountName: " + AccountName() + "\n-AccountNumber: " + AccountNumber() + "\n-AccountServer: " + AccountServer());
   
   veHighLow();
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
  if(SendMessage == true)
      SendNotification("-EA OnDeinit AccountName: " + AccountName() + "\n-AccountNumber: " + AccountNumber() + "\n-AccountServer: " + AccountServer());
   deleteHighLow();
   
  }   
  
bool checkngayTrade(){
   bool kq = false;
   //if(DayOfWeek()==4 || DayOfWeek()==5)
   //   kq = true;
   if (
    ((DayOfWeek() == 1) && (Monday)) ||
    ((DayOfWeek() == 2) && (Tuesday)) ||
    ((DayOfWeek() == 3) && (Wednesday)) ||
    ((DayOfWeek() == 4) && (Thursday)) ||
    ((DayOfWeek() == 5) && (Friday)) )
    {
        kq=true;
    }
   Comment("Trade: ", kq);
   return kq;
}   
                                     

void OnTick()
  { 
      Comment("Trading: ", checkngayTrade());
     
      if(last != Time[0] && checkngayTrade()==true && UseRiskPercent==false){
      
      veHighLow();
      //Xoa lenh cu
      XoaLenhCu(Magic);
      
      //Buy D1
      if(D1==true)
         buysellD1();
      if(W1==true)   
         buysellW1();
      if(MN1==true)   
         buysellMN1();
      
      last = Time[0];
      }
    
      
      if(last != Time[0] && checkngayTrade()==true && UseRiskPercent==true){
         veHighLow();

         //Xoa lenh cu
         XoaLenhCu(Magic);
      
         //Buy D1
         if(D1==true)
            buysellD1Risk();
         if(W1==true)   
            buysellW1Risk();
         if(MN1==true)   
            buysellMN1Risk();
    
         last = Time[0];
   }
      
   
   
   if(TrailingStop==true){
         trailingBUY();
         trailingSELL();
   }
   
   
 }
 
 void trailingBUY(){
   for(int b=OrdersTotal()-1; b>=0; b--){
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY) {
               if(OrderStopLoss() < Ask-(Step*Point*10))
                  OrderModify(
                     OrderTicket(),
                     OrderOpenPrice(),
                     Ask - (Step*Point*10),
                     OrderTakeProfit(),
                     0,
                     CLR_NONE
                  
                  );
            }
   }
 }
 
 void trailingSELL(){
   for(int b=OrdersTotal()-1; b>=0; b--){
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_SELL) {
               if(OrderStopLoss() > Bid+(Step*Point*10))
                  OrderModify(
                     OrderTicket(),
                     OrderOpenPrice(),
                     Bid + (Step*Point*10),
                     OrderTakeProfit(),
                     0,
                     CLR_NONE
                  
                  );
            }
   }
 }
  

 void XoaLenhCu(string comm){
   for (int i=OrdersTotal()-1; i>=0; i--){
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() == Magic){
         SendNotification("Delete command: " + Symbol() + "@" + OrderTicket());
         OrderDelete(OrderTicket(), Red);
      }
   }
 }
 
 void buysellD1Risk(){
      soTienRuiRo = NormalizeDouble(AccountBalance()*RiskPercent/100, 2);
      lotGiaoDich = NormalizeDouble(soTienRuiRo/(SL*10),2);
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      if(lotGiaoDich>MaxLot){
         lotGiaoDich=MaxLot;
      }
      
      //BUY D1
      D1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      lotGiaoDich,
      iHigh(Symbol(), PERIOD_D1, 1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      if(SendMessage == true)
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)D1Buy + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + (iHigh(Symbol(), PERIOD_D1, 1)) 
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10));
      
      
      //SELL D1
      D1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      if(SendMessage == true)
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)D1Sell + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + (iLow(Symbol(), PERIOD_D1, 1)) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_D1, 1) - SL*Point*10));
      
      
 }
 
 void buysellD1(){
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      //BUY D1
      D1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot,
      iHigh(Symbol(), PERIOD_D1,1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)D1Buy + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + iHigh(Symbol(), PERIOD_D1,1)
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_D1,1) - SL*Point*10));
   
      
      //SELL D1
      D1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)D1Sell + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + (iLow(Symbol(), PERIOD_D1, 1)) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_D1, 1) - SL*Point*10));
     
 }
 
 void buysellW1Risk(){
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      soTienRuiRo = NormalizeDouble(AccountBalance()*RiskPercent/100, 2);
      lotGiaoDich = NormalizeDouble(soTienRuiRo/(SL*10),2);
      if(lotGiaoDich>MaxLot){
         lotGiaoDich=MaxLot;
      }
      
      //BUY W1
      W1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      lotGiaoDich,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)W1Buy + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + iHigh(Symbol(), PERIOD_W1, 1) 
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10));
      
      
      //SELL W1
      W1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)W1Sell + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + iLow(Symbol(), PERIOD_W1, 1) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_W1, 1) - SL*Point*10));
     
 }
 
 void buysellW1(){
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      //BUY W1
      W1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)W1Buy + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + iHigh(Symbol(), PERIOD_W1, 1) 
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10));
      
     
      
      //SELL W1
      W1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)W1Sell + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + iLow(Symbol(), PERIOD_W1, 1) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_W1, 1) - SL*Point*10));
      
     
 }
 
 void buysellMN1Risk(){
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      soTienRuiRo = NormalizeDouble(AccountBalance()*RiskPercent/100, 2);
      lotGiaoDich = NormalizeDouble(soTienRuiRo/(SL*10),2);
      if(lotGiaoDich>MaxLot){
         lotGiaoDich=MaxLot;
      }
      
      //BUY MN1
      MN1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      lotGiaoDich,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)MN1Buy + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + iHigh(Symbol(), PERIOD_MN1, 1) 
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10));
    
      
      //SELL MN1
      MN1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " + Symbol() + "@"
                        + (string)MN1Sell + "\n- lotGiaoDich: " 
                        + lotGiaoDich 
                        + "\n- Price: " 
                        + iLow(Symbol(), PERIOD_MN1, 1) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_MN1, 1) - SL*Point*10));
      
     
 }
 
 void buysellMN1(){
      if(Lot==0){
         Alert("Error Lot=", Lot);
         return;
      }
      //BUY MN1
      MN1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " 
                        + (string)MN1Buy + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + iHigh(Symbol(), PERIOD_MN1, 1) 
                        + "\n- SL: " 
                        + (iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10));
    
      
      //SELL MN1
      MN1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      0,
      Comm,
      Magic
      );
      
      SendNotification("- New command: " 
                        + (string)MN1Buy + "\n- lotGiaoDich: " 
                        + Lot 
                        + "\n- Price: " 
                        + iLow(Symbol(), PERIOD_MN1, 1) 
                        + "\n- SL: " 
                        + (iLow(Symbol(), PERIOD_MN1, 1) - SL*Point*10));
     
 }
 
 
 void deleteHighLow(){
   ObjectsDeleteAll(0,"D1_H");
   ObjectsDeleteAll(0,"D1_L"); 
   ObjectsDeleteAll(0,"W1_H");
   ObjectsDeleteAll(0,"W1_L");
   ObjectsDeleteAll(0,"MN1_H");
   ObjectsDeleteAll(0,"MN1_L");
 
 }
 
 void veHighLow(){
   ObjectsDeleteAll(0,"D1_H");
   ObjectsDeleteAll(0,"D1_L"); 
   ObjectsDeleteAll(0,"W1_H");
   ObjectsDeleteAll(0,"W1_L");
   ObjectsDeleteAll(0,"MN1_H");
   ObjectsDeleteAll(0,"MN1_L");
     
   //Draw D1 iHigh
   ObjectCreate("D1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_D1, 1));
   ObjectSet("D1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("D1_H", OBJPROP_COLOR, Purple);
   ObjectSet("D1_H", OBJPROP_WIDTH, 0);
   
   //Draw D1 iLow
   ObjectCreate("D1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_D1, 1));
   ObjectSet("D1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("D1_L", OBJPROP_COLOR, Purple);
   ObjectSet("D1_L", OBJPROP_WIDTH, 0);
   
   //Draw W1 iHigh
   ObjectCreate("W1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_W1, 1));
   ObjectSet("W1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("W1_H", OBJPROP_COLOR, Orange);
   ObjectSet("W1_H", OBJPROP_WIDTH, 0);
   
   //Draw W1 iLow
   ObjectCreate("W1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_W1, 1));
   ObjectSet("W1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("W1_L", OBJPROP_COLOR, Orange);
   ObjectSet("W1_L", OBJPROP_WIDTH, 0);
   
   //Draw MN1 iHigh
   ObjectCreate("MN1_H", OBJ_HLINE , 0,Time[0], iHigh(Symbol(), PERIOD_MN1, 1));
   ObjectSet("MN1_H", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("MN1_H", OBJPROP_COLOR, Blue);
   ObjectSet("MN1_H", OBJPROP_WIDTH, 0);
   
   //Draw MN1 iLow
   ObjectCreate("MN1_L", OBJ_HLINE , 0,Time[0], iLow(Symbol(), PERIOD_MN1, 1));
   ObjectSet("MN1_L", OBJPROP_STYLE, STYLE_DOT);
   ObjectSet("MN1_L", OBJPROP_COLOR, Blue);
   ObjectSet("MN1_L", OBJPROP_WIDTH, 0);
}
