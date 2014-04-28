using UnityEngine;
using System.Collections;

using MySql.Data;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Collections.Generic;

public class NewPointScript : MonoBehaviour {

    public bool autoSwitch;

    Double anchorUnityX, anchorUnityY, anchorAtlasI, anchorAtlasJ, pixelsPerMeter;
    //Double anchorAtlasX, anchorAtlasY;

    string conStr = "Server=straylight.cs.st-andrews.ac.uk;Port=9016;Database=indooratlasdb;User ID=indooratlasuser;Password=u36prsiT;Pooling=true;CharSet=utf8;";
	MySqlConnection con = null;
	MySqlCommand cmd = null;
	MySqlDataReader read = null;

    Vector3 newPos;
    Boolean virt = false;
	
	// Use this for initialization
	void Start () {

		try {
			con = new MySqlConnection(conStr);
			con.Open();
			Debug.Log ("Database connection state: " + con.State);
		} catch (Exception e) {
			Debug.Log(e.ToString());
		}
		
        // THIS IS HOW OFTEN WE QUERY THE DB (in seconds) FOR NEW POSITION DATA - THIS IS INDEPENDENT OF HOW FREQUENTLY NEW DATA ARE BEING INJECTED TO THE DB (which is event driven?)
		StartCoroutine(QueryDB(1.0f));
	}
	
	// Update is called once per frame
	void Update () {
        anchorUnityX = GameObject.Find("AnchorPoint").transform.position.x;
        anchorUnityY = GameObject.Find("AnchorPoint").transform.position.z;
        //anchorAtlasX = GameObject.Find("AnchorPoint").GetComponent<AnchorPointScript>().anchorAtlasX;
        //anchorAtlasY = GameObject.Find("AnchorPoint").GetComponent<AnchorPointScript>().anchorAtlasY;
        anchorAtlasI = GameObject.Find("AnchorPoint").GetComponent<AnchorPointScript>().anchorAtlasI;
        anchorAtlasJ = GameObject.Find("AnchorPoint").GetComponent<AnchorPointScript>().anchorAtlasJ;
        pixelsPerMeter = GameObject.Find("AnchorPoint").GetComponent<AnchorPointScript>().pixelsPerMeter;

        // We want lerp'd movement here, as this is every frame whereas the db query is less frequent
        // Lerp ( old position, new position, damping )
        // damping is a value between 0 & 1, where 0 means you will never get to the new position & 1 means you will get there instantly
        //Debug.Log("new pos: " + newPos);
        //this.transform.position = Vector3.Lerp(transform.position, newPos, 0.3f);

        //Vector3 fooPos = new Vector3(9.168218f, 1.334755f, -7.694644f);   
        //this.transform.position = Vector3.Lerp(transform.position, fooPos, 0.3f);

        if (!(float.IsPositiveInfinity(newPos.x)) && !(float.IsNegativeInfinity(newPos.x)) && 
            !(float.IsPositiveInfinity(newPos.y)) && !(float.IsNegativeInfinity(newPos.y)) &&
            !(float.IsPositiveInfinity(newPos.z)) && !(float.IsNegativeInfinity(newPos.z)) ) {
            this.transform.position = Vector3.Lerp(transform.position, newPos, 0.1f);
        }

        //GameObject.Find("CameraLeft").camera.cullingMask = 1 << 0;
        //GameObject.Find("CameraRight").camera.cullingMask = 1 << 0;

        // *** commented out for phone version, uncomment for Rift version
        // Switch between webcams & Unity cameras according to phone touches

        //if (autoSwitch) {
        //    if (virt)
        //    {
        //        //Debug.Log("virtual is true");
        //        GameObject.Find("CameraLeft").camera.cullingMask = 1 << 0;
        //        GameObject.Find("CameraRight").camera.cullingMask = 1 << 0;
        //    }
        //    else
        //    {
        //        //Debug.Log("virtual is false");
        //        GameObject.Find("CameraLeft").camera.cullingMask = 1 << 30;
        //        GameObject.Find("CameraRight").camera.cullingMask = 1 << 31;
        //    }
        //}

        if (autoSwitch)
        {
            if (virt)
            {
                //Debug.Log("virtual is true");
                GameObject.Find("CameraLeft").camera.cullingMask = 1 << 30;
                GameObject.Find("CameraRight").camera.cullingMask = 1 << 31;
            }
            else
            {
                //Debug.Log("virtual is false");
                GameObject.Find("CameraLeft").camera.cullingMask = 1 << 0;
                GameObject.Find("CameraRight").camera.cullingMask = 1 << 0;
            }
        }
        
	}
	
	IEnumerator QueryDB(float seconds) {

        double xDiff, yDiff, xNewPos, yNewPos;

		while (true) {
            // My Nexus 5
            //string query = "SELECT x, y from devicelocations where deviceID = '4192fe2d3b7fbf27';";
            string query = "SELECT i, j, virtual from devicelocations where deviceID = '4192fe2d3b7fbf27';";

            //Group's Nexus 4
            //string query = "SELECT x, y from devicelocations where deviceID = 'c76129348d8acd2e';";
            //string query = "SELECT i, j, virtual from devicelocations where deviceID = 'c76129348d8acd2e';";

			try {
				if (con.State.CompareTo(ConnectionState.Open) != 0) {
                    con.Open(); //this line causes the windows-1252 encoding error if I18N DLLs are not included, even though it only OPENS the connection & hasn't actually requested any data yet (easy solution - include the I18N DLLs)
				}
				using (con) {
					using (cmd = new MySqlCommand(query, con)) {
						read = cmd.ExecuteReader();
						while (read.Read()) {
							for (int i = 0; i < read.FieldCount; i++) {

                                //xDiff = Math.Abs(read.GetDouble(0) - anchorAtlasX);
                                xDiff = Math.Abs((read.GetDouble(0) - anchorAtlasI));
                                Double xDiffMeters = xDiff / pixelsPerMeter;

                                //yDiff = Math.Abs(read.GetDouble(1) - anchorAtlasY);
                                yDiff = Math.Abs((read.GetDouble(1) - anchorAtlasJ));
                                Double yDiffMeters = yDiff / pixelsPerMeter;

                                virt = (read.GetBoolean(2));
                                Debug.Log("virt flag: " + virt);

                                //if (read.GetDouble(0) > anchorAtlasX)
                                if (read.GetDouble(0) > anchorAtlasI)
                                {
                                    //xNewPos = anchorUnityX + xDiff;
                                    xNewPos = anchorUnityX + xDiffMeters;
                                } else {
                                    //xNewPos = anchorUnityX - xDiff;
                                    xNewPos = anchorUnityX - xDiffMeters;
                                }

                                //if (read.GetDouble(1) > anchorAtlasY)
                                if (read.GetDouble(1) > anchorAtlasJ)
                                {
                                    //yNewPos = anchorUnityY - yDiff;
                                    yNewPos = anchorUnityY - yDiffMeters;
                                } else {
                                    //yNewPos = anchorUnityY + yDiff;
                                    yNewPos = anchorUnityY + yDiffMeters;
                                }

                                // Vector of NewPoint
                                newPos = new Vector3((float) xNewPos, (float) transform.position.y, (float) yNewPos);
                                
                                Debug.Log("New Vector3: " + newPos.x + ", " + newPos.y + ", " + newPos.z);
                                
                                // Actual transform (movement) code is in update() as that runs every frame whereas this method only runs every x seconds (it's a coroutine with WaitForSeconds at the end)
							}
						}
					}
				}
	
			} catch (Exception e) {
				Debug.Log(e.ToString());
			}
			Debug.Log("DB query on: " + System.DateTime.Now);
			yield return new WaitForSeconds(seconds);
		}
	}

	void OnApplicationQuit() {
		if (con.State.CompareTo(ConnectionState.Open) == 0) {
			try {
				con.Close();
			} catch (Exception e) {
				Debug.Log (e.ToString());
			}
		}
	}
}
