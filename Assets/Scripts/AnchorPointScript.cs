using UnityEngine;
using System.Collections;

public class AnchorPointScript : MonoBehaviour {

    public double anchorAtlasX, anchorAtlasY, anchorAtlasI, anchorAtlasJ, pixelsPerMeter;

	// Use this for initialization
	void Start () {
        GameObject.Find("AnchorPoint").renderer.material.color = new Color(1.0f, 1.0f, 0f);
	}
	
	// Update is called once per frame
	void Update () {

	}

}
