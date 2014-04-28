using UnityEngine;
using System.Collections;

public class WebCamTextureRight : MonoBehaviour {

	// Use this for initialization
	void Start () {
        WebCamTexture webcamTexture = new WebCamTexture("Logitech HD Webcam C310 1", 1280, 960, 30);
        renderer.material.mainTexture = webcamTexture;
        webcamTexture.Play();
	}
	
	// Update is called once per frame
	void Update () {
	    
	}

}
