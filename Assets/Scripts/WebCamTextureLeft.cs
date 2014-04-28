using UnityEngine;
using System.Collections;

public class WebCamTextureLeft : MonoBehaviour {

	// Use this for initialization
	void Start () {

        WebCamDevice[] devices = WebCamTexture.devices;
        int i = 0;
        while (i < devices.Length)
        {
            Debug.Log(devices[i].name);
            i++;
        }

        WebCamTexture webcamTexture = new WebCamTexture("Logitech HD Webcam C310", 1280, 960, 30);
        renderer.material.mainTexture = webcamTexture;
        webcamTexture.Play();
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
