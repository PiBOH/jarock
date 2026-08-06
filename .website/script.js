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
})();
