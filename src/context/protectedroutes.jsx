import { Navigate } from "react-router-dom";
import useAuth from "./userContext";
export function withProtected(Component) {
    return function WithProtected(props) {
        const auth = useAuth();
        if (!auth.user) {
            return <Navigate to="/" replace />
        }
        return <Component auth={auth} {...props} />;
    };
}

export function withPublic(Component) {
    return function WithPublic(props) {
        const auth = useAuth();

        if (auth.user) {
            return <Navigate to="/dashboard" replace />
        }
        return <Component auth={auth} {...props} />;
    };
}