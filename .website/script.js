(() => {
  const menuButton = document.querySelector('.menu-toggle');
  const navigation = document.querySelector('.top-nav');

  if (menuButton && navigation) {
    menuButton.addEventListener('click', () => {
      const isOpen = navigation.classList.toggle('is-open');
      menuButton.setAttribute('aria-expanded', String(isOpen));
    });

    const closeMenu = () => {
      navigation.classList.remove('is-open');
      menuButton.setAttribute('aria-expanded', 'false');
    };

    navigation.querySelectorAll('a').forEach((link) => {
      link.addEventListener('click', closeMenu);
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') closeMenu();
    });

    document.addEventListener('click', (event) => {
      if (!navigation.contains(event.target) && !menuButton.contains(event.target)) closeMenu();
    });
  }

  const search = document.querySelector('#toolkit-search');
  const rows = [...document.querySelectorAll('#toolkit-list tr')];
  const emptyState = document.querySelector('#empty-state');

  if (search && rows.length && emptyState) {
    search.addEventListener('input', () => {
      const query = search.value.trim().toLowerCase();
      let visibleRows = 0;

      rows.forEach((row) => {
        const matches = !query || row.dataset.search.includes(query);
        row.hidden = !matches;
        if (matches) visibleRows += 1;
      });

      emptyState.hidden = visibleRows !== 0;
    });
  }
})();
