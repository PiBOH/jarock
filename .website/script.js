(() => {
  const menu = document.querySelector('#primary-nav');
  const button = document.querySelector('.menu-toggle');
  if (menu && button) {
    const close = () => { menu.classList.remove('is-open'); button.setAttribute('aria-expanded', 'false'); };
    button.addEventListener('click', () => {
      const open = menu.classList.toggle('is-open');
      button.setAttribute('aria-expanded', String(open));
    });
    menu.querySelectorAll('a').forEach((link) => link.addEventListener('click', close));
    document.addEventListener('keydown', (event) => { if (event.key === 'Escape') close(); });
    document.addEventListener('click', (event) => {
      if (!menu.contains(event.target) && !button.contains(event.target)) close();
    });
  }

  const search = document.querySelector('[data-catalog-search]');
  const rows = [...document.querySelectorAll('[data-catalog-row]')];
  const empty = document.querySelector('[data-empty-search]');
  if (search && rows.length) {
    search.addEventListener('input', () => {
      const query = search.value.trim().toLowerCase();
      let shown = 0;
      rows.forEach((row) => {
        const match = !query || (row.dataset.search || row.textContent).toLowerCase().includes(query);
        row.hidden = !match;
        if (match) shown += 1;
      });
      if (empty) empty.hidden = shown !== 0;
    });
  }
  const changelogBox = document.getElementById('changelog-fetch');
  if (changelogBox) {
    const url = 'https://raw.githubusercontent.com/PiBOH/jarock/refs/heads/main/CHANGELOG.md';
    const fallback = 'https://github.com/PiBOH/jarock/blob/main/CHANGELOG.md';
    fetch(url)
      .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.text(); })
      .then(md => {
        let lines = md.split('\n');
        let html = '';
        let inList = false;
        for (let line of lines) {
          let esc = line.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
          esc = esc.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
          if (/^## /.test(esc)) {
            if (inList) { html += '</ul>'; inList = false; }
            html += '<h2>' + esc.slice(3) + '</h2>';
          } else if (/^### /.test(esc)) {
            if (inList) { html += '</ul>'; inList = false; }
            html += '<h3>' + esc.slice(4) + '</h3>';
          } else if (/^- /.test(esc)) {
            if (!inList) { html += '<ul>'; inList = true; }
            html += '<li>' + esc.slice(2) + '</li>';
          } else if (esc.trim() !== '') {
            if (inList) { html += '</ul>'; inList = false; }
            html += '<p>' + esc + '</p>';
          }
        }
        if (inList) html += '</ul>';
        changelogBox.className = 'download-box';
        changelogBox.innerHTML = html;
      })
      .catch(() => {
        changelogBox.className = 'notice warning';
        changelogBox.innerHTML = '<strong>Could not load the changelog.</strong> Verify the link and read it on GitHub: <a href="' + fallback + '">CHANGELOG.md</a>';
      });
  }

  const releaseSpans = [...document.querySelectorAll('[data-release-package]')];
  if (releaseSpans.length) {
    // Use the LIST endpoint, not /releases/latest: the "latest" endpoint returns
    // HTTP 404 while the newest release is a prerelease, which would keep the
    // buttons on the fallback message for the whole beta channel. The list is
    // ordered newest-first and includes prereleases.
    const apiUrl = 'https://api.github.com/repos/PiBOH/jarock/releases?per_page=5';
    const releasesFallback = 'https://github.com/PiBOH/jarock/releases';
    const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    fetch(apiUrl)
      .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
      .then(list => {
        if (!Array.isArray(list) || !list.length) throw new Error('no releases');
        releaseSpans.forEach(span => {
          const kind = span.dataset.releasePackage; // cli-full, cli-lite, tui-full, or tui-lite
          const prefix = 'jarock-' + kind;
          const rel = list.find(r => (r.assets || []).some(a => a.name.startsWith(prefix) && a.name.endsWith('.zip')));
          if (!rel) {
            span.innerHTML = '<strong>No ' + esc(kind.toUpperCase()) + ' package available yet.</strong> See the <a href="' + releasesFallback + '">releases page</a>.';
            return;
          }
          const asset = rel.assets.find(a => a.name.startsWith(prefix) && a.name.endsWith('.zip'));
          const version = esc(rel.tag_name || 'latest');
          const url = esc(asset.browser_download_url);
          const sizeMb = asset.size ? ' (' + Math.max(1, Math.round(asset.size / 1048576)) + ' MB)' : '';
          span.innerHTML = '<a class="download-link" href="' + url + '">Download ' + esc(kind.toUpperCase()) + ' package (' + version + ')' + sizeMb + '</a>';
        });
      })
      .catch(() => {
        releaseSpans.forEach(span => {
          span.innerHTML = '<strong>Could not load the latest release.</strong> Check the <a href="' + releasesFallback + '">releases page</a>.';
        });
      });
  }
})();
