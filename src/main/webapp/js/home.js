document.addEventListener("DOMContentLoaded", function () {

    "use strict";


    /* =========================================================
       POPULAR PRODUCTS
       5 BANNERS
       AUTOMATIC CHANGE EVERY 3 SECONDS
       NO ARROWS
       NO TIMER TEXT
    ========================================================= */

    const popularSlides =
        Array.from(
            document.querySelectorAll(
                "#popularSlides .popular-slide"
            )
        );

    const popularDots =
        Array.from(
            document.querySelectorAll(
                "#popularDots .carousel-dot"
            )
        );

    const popularCarousel =
        document.getElementById(
            "popularCarousel"
        );

    let popularIndex = 0;
    let popularTimer = null;


    function showPopular(index) {

        if (!popularSlides.length) {
            return;
        }

        popularIndex =
            (index + popularSlides.length)
            % popularSlides.length;


        popularSlides.forEach(
            function (slide, i) {

                slide.classList.toggle(
                    "active",
                    i === popularIndex
                );

            }
        );


        popularDots.forEach(
            function (dot, i) {

                dot.classList.toggle(
                    "active",
                    i === popularIndex
                );

            }
        );
    }


    function restartPopular() {

        if (popularTimer) {

            clearInterval(
                popularTimer
            );
        }


        popularTimer =
            setInterval(
                function () {

                    showPopular(
                        popularIndex + 1
                    );

                },
                3000
            );
    }


    popularDots.forEach(
        function (dot) {

            dot.addEventListener(
                "click",
                function () {

                    const index =
                        Number(
                            this.dataset.slideTo
                        );

                    if (
                        !Number.isNaN(index)
                    ) {

                        showPopular(index);

                        restartPopular();
                    }

                }
            );

        }
    );


    if (popularSlides.length) {

        showPopular(0);

        restartPopular();
    }


    if (popularCarousel) {

        popularCarousel.addEventListener(
            "mouseenter",
            function () {

                if (popularTimer) {

                    clearInterval(
                        popularTimer
                    );
                }

            }
        );


        popularCarousel.addEventListener(
            "mouseleave",
            function () {

                restartPopular();

            }
        );
    }


    /* =========================================================
       EXPLORE NEW
       2 BANNERS
       AUTOMATIC CHANGE EVERY 4 SECONDS
    ========================================================= */

    const heroSlides =
        Array.from(
            document.querySelectorAll(
                "#heroSlides .hero-slide"
            )
        );

    const heroCarousel =
        document.getElementById(
            "heroCarousel"
        );

    let heroIndex = 0;
    let heroTimer = null;


    function showHero(index) {

        if (!heroSlides.length) {
            return;
        }

        heroIndex =
            (index + heroSlides.length)
            % heroSlides.length;


        heroSlides.forEach(
            function (slide, i) {

                slide.classList.toggle(
                    "active",
                    i === heroIndex
                );

            }
        );
    }


    function restartHero() {

        if (heroTimer) {

            clearInterval(
                heroTimer
            );
        }


        heroTimer =
            setInterval(
                function () {

                    showHero(
                        heroIndex + 1
                    );

                },
                4000
            );
    }


    if (heroSlides.length) {

        showHero(0);

        restartHero();
    }


    if (heroCarousel) {

        heroCarousel.addEventListener(
            "mouseenter",
            function () {

                if (heroTimer) {

                    clearInterval(
                        heroTimer
                    );
                }

            }
        );


        heroCarousel.addEventListener(
            "mouseleave",
            function () {

                restartHero();

            }
        );
    }


    /* =========================================================
       SEARCH
       COMPACT ICON -> SEARCH FIELD
    ========================================================= */

    const searchForm =
        document.getElementById(
            "searchForm"
        );


    if (searchForm) {

        const input =
            searchForm.querySelector(
                "input"
            );

        const button =
            searchForm.querySelector(
                "button"
            );


        searchForm.classList.remove(
            "search-open"
        );


        button.addEventListener(
            "click",
            function (event) {

                if (
                    !searchForm.classList.contains(
                        "search-open"
                    )
                ) {

                    event.preventDefault();

                    searchForm.classList.add(
                        "search-open"
                    );

                    input.focus();

                }

            }
        );


        input.addEventListener(
            "keydown",
            function (event) {

                if (
                    event.key === "Enter"
                    && input.value.trim() === ""
                ) {

                    event.preventDefault();

                }

            }
        );


        document.addEventListener(
            "click",
            function (event) {

                if (
                    !searchForm.contains(
                        event.target
                    )
                    && input.value.trim() === ""
                ) {

                    searchForm.classList.remove(
                        "search-open"
                    );

                }

            }
        );
    }


    /* =========================================================
       SIDEBAR SECTION HIGHLIGHT
    ========================================================= */

    const sectionLinks =
        Array.from(
            document.querySelectorAll(
                ".js-section-link"
            )
        );


    const sections = [

        document.getElementById(
            "home-dashboard"
        ),

        document.getElementById(
            "popular-products"
        ),

        document.getElementById(
            "explore-new"
        )

    ].filter(Boolean);


    function setActiveSection(id) {

        sectionLinks.forEach(
            function (link) {

                link.classList.toggle(
                    "active",
                    link.dataset.section === id
                );

            }
        );
    }


    sectionLinks.forEach(
        function (link) {

            link.addEventListener(
                "click",
                function () {

                    setActiveSection(
                        link.dataset.section
                    );

                }
            );

        }
    );


    function updateActiveSection() {

        const marker =
            window.scrollY + 180;

        let current =
            "home-dashboard";


        sections.forEach(
            function (section) {

                if (
                    marker >= section.offsetTop
                ) {

                    current =
                        section.id;

                }

            }
        );


        setActiveSection(
            current
        );
    }


    window.addEventListener(
        "scroll",
        updateActiveSection,
        {
            passive: true
        }
    );


    updateActiveSection();


    /* =========================================================
       LOGIN SUCCESS MESSAGE
    ========================================================= */

    const notification =
        document.querySelector(
            ".login-success-notification"
        );


    if (notification) {

        setTimeout(
            function () {

                notification.remove();

            },
            5000
        );

    }

});