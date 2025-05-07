// Add external script to the addin :

// YDF inference (84Ko)
var YDF_Inference_Script = document.createElement('script');
YDF_Inference_Script.setAttribute('src','https://cdn.jsdelivr.net/npm/ydf-inference@0.0.4/dist/inference.min.js');
document.head.appendChild(YDF_Inference_Script);

// YDF Training (86Ko)
var YDF_Training_Script = document.createElement('script');
YDF_Training_Script.setAttribute('src','https://cdn.jsdelivr.net/npm/ydf-training@0.0.1/dist/training.min.js');
document.head.appendChild(YDF_Training_Script);

// JS zip lib (96Ko)
var JSZip_Script = document.createElement('script');
JSZip_Script.setAttribute('src','https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.0/jszip.min.js');
document.head.appendChild(JSZip_Script);

// Trigger Addin ready
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("AddinReady",[],!1);