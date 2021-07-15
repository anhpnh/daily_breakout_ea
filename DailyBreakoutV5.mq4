#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.05"
#property strict
//--- input parameters
input string   Scalping="D1, W1, MN1 Breakout";
input bool D1=true;
input bool W1=true;
input bool MN1=true;
input string   Lot="Static";
input double   Lot1=0.01;
input string   Stoploss="Pip";
input double   SL=5.0;
input string   TakeProfit="Pip";
input double   TP=15.0;
input bool     TrailingStop=true;
input bool     UseRiskPercent=true;
input double   MaxLot=200.0;
input string   Risk="% AccountBalance";
input double   RiskPercent=1.0;
input string   Magic="123456789";
input bool     TimeTrading=false;
input string   Start_Time="14";
input string   Finish_Time="5";
int StartTime,FinishTime, Current_Time;
datetime last;
double soTienRuiRo;
double lotGiaoDich;
int    D1Buy, D1Sell, W1Buy, W1Sell, MN1Buy, MN1Sell;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {

   

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {

   
  }   
  
bool checkthuHai(){
   bool kq = false;
   if(DayOfWeek()==0)
      kq = true;
   return kq;
}   

bool CheckTradingTime(){
   Current_Time = TimeHour(TimeLocal());
   if (StringToInteger(Start_Time) == 0) StartTime = 24; if (StringToInteger(Finish_Time) == 0) FinishTime = 24; if (Current_Time == 0) Current_Time = 24;
      
   if ( Start_Time < Finish_Time )
      if ( (Current_Time < Start_Time) || (Current_Time >= Finish_Time) ) return(false);
      
   if ( Start_Time > Finish_Time )
      if ( (Current_Time < Start_Time) && (Current_Time >= Finish_Time) ) return(false);
      
   return(true); 
   
}                                      

void OnTick()
  {
   
   if(TimeTrading==true){
      if(CheckTradingTime() == false){
      //Xoa lenh cu
      XoaLenhCu(Magic);
      }
   
      if(CheckTradingTime() == true){
         if(last != Time[0] && !checkthuHai() && UseRiskPercent==false){
      
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
   
      if(last != Time[0] && !checkthuHai() && UseRiskPercent==true){
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
   
   }
   
   
   if(TrailingStop==true){
         trailingBUY();
         trailingSELL();
   }
   
   Comment(
      "- TradingIsAllowed= ", CheckTradingTime(), "\n",
      "- Current Time= ", Current_Time, "\n",
      "- Start Trading Time= ", Start_Time, "\n",
      "- Finish Trading Time= ", Finish_Time
   );
 }
   
   
   if(last != Time[0] && !checkthuHai() && UseRiskPercent==false){
      
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
   
      if(last != Time[0] && !checkthuHai() && UseRiskPercent==true){
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
   
   Comment(
      "- TradingIsAllowed= ", CheckTradingTime(), "\n",
      "- Current Time= ", Current_Time, "\n",
      "- Start Trading Time= ", Start_Time, "\n",
      "- Finish Trading Time= ", Finish_Time
   );
   
 }
 
 void trailingBUY(){
   for(int b=OrdersTotal()-1; b>=0; b--){
      if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY) {
               if(OrderStopLoss() < Ask-(SL*Point*10))
                  OrderModify(
                     OrderTicket(),
                     OrderOpenPrice(),
                     Ask - (SL*Point*10),
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
               if(OrderStopLoss() > Bid+(SL*Point*10))
                  OrderModify(
                     OrderTicket(),
                     OrderOpenPrice(),
                     Bid + (SL*Point*10),
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
      if(OrderComment() == Magic){
         OrderDelete(OrderTicket(), Red);
      }
   }
 }
 
 void buysellD1Risk(){
      soTienRuiRo = NormalizeDouble(AccountBalance()*RiskPercent/100, 2);
      lotGiaoDich = NormalizeDouble(soTienRuiRo/(SL*10),2);
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
      Magic
      );
      
      
      //SELL D1
      D1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      0,
      Magic
      );
      
 }
 
 void buysellD1(){
      //BUY D1
      D1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_D1, 1),
      0,
      iHigh(Symbol(), PERIOD_D1, 1) - SL*Point*10,
      00,
      Magic
      );
   
      
      //SELL D1
      D1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_D1, 1),
      0,
      iLow(Symbol(), PERIOD_D1, 1) + SL*Point*10,
      0,
      Magic
      );
     
 }
 
 void buysellW1Risk(){
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
      Magic
      );
      
      
      //SELL W1
      W1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      0,
      Magic
      );
      
     
 }
 
 void buysellW1(){
   //BUY W1
      W1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_W1, 1),
      0,
      iHigh(Symbol(), PERIOD_W1, 1) - SL*Point*10,
      0,
      Magic
      );
      
     
      
      //SELL W1
      W1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_W1, 1),
      0,
      iLow(Symbol(), PERIOD_W1, 1) + SL*Point*10,
      0,
      Magic
      );
      
     
 }
 
 void buysellMN1Risk(){
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
      Magic
      );
      
    
      
      //SELL MN1
      MN1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      lotGiaoDich,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      0,
      Magic
      );
      
     
 }
 
 void buysellMN1(){
   //BUY MN1
      MN1Buy = OrderSend(
      Symbol(),
      OP_BUYSTOP,
      Lot1,
      iHigh(Symbol(), PERIOD_MN1, 1),
      0,
      iHigh(Symbol(), PERIOD_MN1, 1) - SL*Point*10,
      0,
      Magic
      );
    
      
      //SELL MN1
      MN1Sell = OrderSend(
      Symbol(),
      OP_SELLSTOP,
      Lot1,
      iLow(Symbol(), PERIOD_MN1, 1),
      0,
      iLow(Symbol(), PERIOD_MN1, 1) + SL*Point*10,
      0,
      Magic
      );
      
     
 }
 
 
 void veHighLow(){
   Comment("- High D1: "+(string)iHigh(Symbol(), PERIOD_D1, 1) + "\n" + "- Low D1: "+(string)iLow(Symbol(), PERIOD_D1, 1) + "\n"
   +       "- High W1: "+(string)iHigh(Symbol(), PERIOD_W1, 1) + "\n" + "- Low W1: "+(string)iLow(Symbol(), PERIOD_W1, 1) + "\n"
   +       "- High MN1: "+(string)iHigh(Symbol(), PERIOD_MN1, 1) + "\n" + "- Low MN1: "+(string)iLow(Symbol(), PERIOD_MN1, 1) + "\n"
   );
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