/* ==========================================================================
   Main JavaScript Functionality:
   ========================================================================== */

// Waits for the DOM content to be fully loaded before executing the code
document.addEventListener("DOMContentLoaded", function() {
    // Selects all 'section' elements on the page
    const sections = document.querySelectorAll('section');

    // Function to handle section animations
    function handleSectionAnimations() {
        // Iterates over each section
        sections.forEach(section => {
            // Retrieves the top position of the section
            const sectionTop = section.offsetTop;
            
            // Retrieves the height of the section
            const sectionHeight = section.clientHeight;
            
            // Retrieves the current scroll position
            const scrollY = window.scrollY;
            
            // Retrieves the height of the viewport
            const windowHeight = window.innerHeight;
            
            // Checks if the section is in the viewport
            if (scrollY > sectionTop - windowHeight + sectionHeight / 2) {
                // Adds the 'fade-in' class to the section for animation
                section.classList.add('fade-in');
            }
        });
    }

    // Listens for scroll events and triggers the section animations function
    window.addEventListener('scroll', handleSectionAnimations);
    
    // Runs the function once on page load to handle initial section animations
    handleSectionAnimations();
});