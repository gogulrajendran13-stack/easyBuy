
package easyBuy.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/invite-friend")
public class InviteFriendController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Build the EasyBuy registration invitation URL.
        String inviteUrl = request.getScheme()
                + "://"
                + request.getServerName();

        int port = request.getServerPort();

        if (port != 80 && port != 443) {
            inviteUrl += ":" + port;
        }

        inviteUrl += request.getContextPath() + "/register";

        // Send the invitation URL to the JSP.
        request.setAttribute("inviteUrl", inviteUrl);

        // Display the Invite Friends page.
        request.getRequestDispatcher("/invite-friend.jsp")
               .forward(request, response);
    }
}
