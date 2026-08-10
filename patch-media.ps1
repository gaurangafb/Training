# Patch script: Replace file-picker approach with direct src references for media files

$file = "c:\Users\Gaurang\Downloads\Training Module\sri-mandir-astrologer-onboarding.html"
$content = [System.IO.File]::ReadAllText($file)

# 1. Replace the video file picker section with direct video embed
$oldVideo = @'
        <div class="kg-video-wrap">
          <div class="kv-label"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#8B1E1E" stroke-width="2"><path d="M23 7l-7 5 7 5V7z"/><rect x="1" y="5" width="15" height="14" rx="2"/></svg>Watch: sending a remedy end-to-end</div>
          <label for="remedyVideoPicker" style="display:flex;align-items:center;justify-content:center;gap:8px;
            border:1.5px dashed var(--saffron);border-radius:11px;padding:14px;cursor:pointer;font-size:12.5px;
            font-weight:700;color:var(--saffron-deep);background:#fff;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 16V4M12 4l-4 4M12 4l4 4"/><path d="M4 16v3a2 2 0 002 2h12a2 2 0 002-2v-3"/></svg>
            Load the walkthrough (remedy-flow-walkthrough.mp4)
          </label>
          <input type="file" id="remedyVideoPicker" accept="video/*" style="display:none;">
          <video id="remedyVideo" controls preload="none" style="width:100%;border-radius:11px;margin-top:10px;display:none;background:#000;"></video>
          <div id="remedyVideoStatus" style="font-size:11px;color:var(--muted);margin-top:6px;"></div>
        </div>
'@

$newVideo = @'
        <div class="kg-video-wrap">
          <div class="kv-label"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#8B1E1E" stroke-width="2"><path d="M23 7l-7 5 7 5V7z"/><rect x="1" y="5" width="15" height="14" rx="2"/></svg>Watch: sending a remedy end-to-end</div>
          <video id="remedyVideo" controls preload="metadata" src="remedy-flow-walkthrough.mp4" style="width:100%;border-radius:11px;margin-top:10px;background:#000;"></video>
          <div id="remedyVideoStatus" style="font-size:11px;color:var(--muted);margin-top:6px;"></div>
        </div>
'@

$content = $content.Replace($oldVideo, $newVideo)

# 2. Replace the audio file picker section with direct audio embed
$oldAudio = @'
            <label for="audioPicker" style="display:flex;align-items:center;justify-content:center;gap:8px;
              border:1.5px dashed var(--saffron);border-radius:11px;padding:14px;cursor:pointer;font-size:12.5px;
              font-weight:700;color:var(--saffron-deep);background:#fff;">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 16V4M12 4l-4 4M12 4l4 4"/><path d="M4 16v3a2 2 0 002 2h12a2 2 0 002-2v-3"/></svg>
              Load the recording (Sri-Mandir-Ideal-Consultation.m4a)
            </label>
            <input type="file" id="audioPicker" accept="audio/*" style="display:none;">
            <audio id="consultAudio" controls preload="none" style="width:100%;height:40px;display:none;"></audio>
            <div id="audioFallback" style="font-size:11px;color:var(--muted);"></div>
          </div>
          <div class="note-box" style="margin-top:14px;">The recording is provided as a separate file alongside this module — click above and select it once, then play it right here. Nothing is uploaded anywhere; the file stays on your device.</div>
'@

$newAudio = @'
            <audio id="consultAudio" controls preload="metadata" src="Sri-Mandir-Ideal-Consultation.m4a" style="width:100%;height:40px;"></audio>
            <div id="audioFallback" style="font-size:11px;color:var(--muted);"></div>
          </div>
          <div class="note-box" style="margin-top:14px;">The recording plays directly from this module's folder — just press play. Nothing is uploaded anywhere; the file stays on your device.</div>
'@

$content = $content.Replace($oldAudio, $newAudio)

# 3. Replace the JS file picker event listeners with a simple comment
$oldJS = @'
  // Ideal Consultation: local file picker -> audio player (no network/embedding involved)
  const audioPicker = document.getElementById('audioPicker');
  if(audioPicker){
    audioPicker.addEventListener('change', function(e){
      const file = e.target.files && e.target.files[0];
      const audioEl = document.getElementById('consultAudio');
      const fb = document.getElementById('audioFallback');
      if(!file){ return; }
      try{
        const url = URL.createObjectURL(file);
        audioEl.src = url;
        audioEl.style.display = 'block';
        audioEl.play().catch(()=>{});
        fb.textContent = 'Loaded: ' + file.name;
      }catch(err){
        fb.textContent = 'Could not load that file: ' + err.message;
      }
    });
  }

  // Kundli Guide: local file picker -> video player (same proven pattern as the audio player)
  const remedyVideoPicker = document.getElementById('remedyVideoPicker');
  if(remedyVideoPicker){
    remedyVideoPicker.addEventListener('change', function(e){
      const file = e.target.files && e.target.files[0];
      const videoEl = document.getElementById('remedyVideo');
      const fb = document.getElementById('remedyVideoStatus');
      if(!file){ return; }
      try{
        const url = URL.createObjectURL(file);
        videoEl.src = url;
        videoEl.style.display = 'block';
        videoEl.play().catch(()=>{});
        fb.textContent = 'Loaded: ' + file.name;
      }catch(err){
        fb.textContent = 'Could not load that file: ' + err.message;
      }
    });
  }
'@

$newJS = @'
  // Audio and video are now directly embedded via src attributes —
  // no file pickers needed. The media files sit alongside this HTML file.
'@

$content = $content.Replace($oldJS, $newJS)

[System.IO.File]::WriteAllText($file, $content)
Write-Host "Done! Media files are now directly embedded."
