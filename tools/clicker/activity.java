package com.bala.manualcount;

import android.app.Activity;
import android.app.ActionBar;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.os.Bundle;
import android.os.Environment;
import android.widget.TextView;
import android.widget.LinearLayout;
import android.widget.Toast;
import android.widget.Button;
import android.net.Uri;
import java.util.Random;
import java.util.Calendar;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.io.File;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;

public class MainActivity extends Activity {
@Override
protected void onCreate(Bundle savedInstanceState) {
ActionBar actionBar = getActionBar();
actionBar.hide();
  super.onCreate(savedInstanceState);
  setContentView(R.layout.activity_main);
  TextView text = (TextView)findViewById(R.id.my_text);
text.setText("0");
File root = new File(Environment.getExternalStorageDirectory(),
    "ManualCounts");
if (!root.exists()) { root.mkdirs(); }
Button left = (Button)findViewById(R.id.b_left);
left.setOnClickListener(new View.OnClickListener(){
  @Override
  public void onClick(View view) { try {
    Date date = Calendar.getInstance().getTime();
    DateFormat preciseTime = 
       new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
    DateFormat justDate = new SimpleDateFormat("yyyy-MM-dd");
    File root = new File(Environment.getExternalStorageDirectory(), 
        "ManualCounts");
    File csvfile = new File(root,justDate.format(date)+".csv");
    FileWriter fwriter = new FileWriter(csvfile,true);
    BufferedWriter writer = new BufferedWriter(fwriter);
    String strDate = preciseTime.format(date);
    writer.append("\""+strDate+"\",\"left\"");
    writer.newLine();
    writer.close();
        TextView text = (TextView)findViewById(R.id.my_text);
    int count = Integer.parseInt(text.getText().toString());
    text.setText(Integer.toString(count+1));
    Button left = (Button)findViewById(R.id.b_left);
    int countleft = Integer.parseInt(left.getText().toString());
    left.setText(Integer.toString(countleft+1));
    } catch (IOException e) {
    e.printStackTrace();
    Context context = getApplicationContext();
    Toast.makeText(context, "error", Toast.LENGTH_SHORT).show();
    } } });
Button right = (Button)findViewById(R.id.b_right);
right.setOnClickListener(new View.OnClickListener(){
  @Override
  public void onClick(View view) { try {
    Date date = Calendar.getInstance().getTime();
    DateFormat preciseTime = 
      new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
    DateFormat justDate = new SimpleDateFormat("yyyy-MM-dd");
    File root = new File(Environment.getExternalStorageDirectory(), 
        "ManualCounts");
    File csvfile = new File(root,justDate.format(date)+".csv");
    FileWriter fwriter = new FileWriter(csvfile,true);
    BufferedWriter writer = new BufferedWriter(fwriter);
    String strDate = preciseTime.format(date);
    writer.append("\""+strDate+"\",\"right\"");
    writer.newLine();
    writer.close();
        TextView text = (TextView)findViewById(R.id.my_text);
    int count = Integer.parseInt(text.getText().toString());
    text.setText(Integer.toString(count+1));
    Button right = (Button)findViewById(R.id.b_right);
    int countright = Integer.parseInt(right.getText().toString());
    right.setText(Integer.toString(countright+1));
    } catch (IOException e) {
    e.printStackTrace();
    Context context = getApplicationContext();
    Toast.makeText(context, "error", Toast.LENGTH_SHORT).show();
    } } });
LinearLayout layOut = (LinearLayout)findViewById(R.id.lay);
layOut.setOnClickListener(new View.OnClickListener(){
  @Override
  public void onClick(View view) { try {
    Date date = Calendar.getInstance().getTime();
    DateFormat preciseTime = 
      new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
    DateFormat justDate = new SimpleDateFormat("yyyy-MM-dd");
    File root = new File(Environment.getExternalStorageDirectory(),
        "ManualCounts");
    File csvfile = new File(root,justDate.format(date)+".csv");
    FileWriter fwriter = new FileWriter(csvfile,true);
    BufferedWriter writer = new BufferedWriter(fwriter);
    String strDate = preciseTime.format(date);
    writer.append("\""+strDate+"\",\"other\"");
    writer.newLine();
    writer.close();
        TextView text = (TextView)findViewById(R.id.my_text);
    int count = Integer.parseInt(text.getText().toString());
    text.setText(Integer.toString(count+1));
    } catch (IOException e) {
    e.printStackTrace();
    Context context = getApplicationContext();
    Toast.makeText(context, "error", Toast.LENGTH_SHORT).show();
    } } });
layOut.setOnLongClickListener(new View.OnLongClickListener(){
  @Override
  public boolean  onLongClick(View view) {
    Context context = getApplicationContext();
    Toast.makeText(context,"Sending data",Toast.LENGTH_SHORT).show();
    Intent intentShareFile = new Intent(Intent.ACTION_SEND);
    Date date = Calendar.getInstance().getTime();
    DateFormat justDate = new SimpleDateFormat("yyyy-MM-dd");
    File root = new File(Environment.getExternalStorageDirectory(),
        "ManualCounts");
    File csvfile = new File(root,justDate.format(date)+".csv");
    intentShareFile.setType("text/*");
    intentShareFile.putExtra(Intent.EXTRA_STREAM, 
        Uri.parse("file://"+csvfile.toString()));
    startActivity(Intent.createChooser(intentShareFile, 
          "Share File"));
    return true;
  }
}); } }
